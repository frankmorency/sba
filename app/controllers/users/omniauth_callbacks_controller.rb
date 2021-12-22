class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  if Feature.active?(:idp)
    include DeviseHelper
  end

  skip_before_action :verify_authenticity_token

  # Constants
  C14N    = Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0
  NS_MAP  = {
    "c14n"  => "http://www.w3.org/2001/10/xml-exc-c14n#",
    "ds"    => "http://www.w3.org/2000/09/xmldsig#",
    "saml"  => "urn:oasis:names:tc:SAML:2.0:assertion",
    "samlp" => "urn:oasis:names:tc:SAML:2.0:protocol",
    "md"    => "urn:oasis:names:tc:SAML:2.0:metadata",
    "xsi"   => "http://www.w3.org/2001/XMLSchema-instance",
    "xs"    => "http://www.w3.org/2001/XMLSchema"
  }
  SHA_MAP = {
    1    => OpenSSL::Digest::SHA1,
    256  => OpenSSL::Digest::SHA256,
    384  => OpenSSL::Digest::SHA384,
    512  => OpenSSL::Digest::SHA512
  }

  if !Feature.active?(:idp)
    def saml
      # Read the document
      saml_response_base64 = decode_raw_saml_response(params["SAMLResponse"])
      original = Nokogiri::XML(saml_response_base64)
      document = original.dup
      prefix = "/samlp:Response"

      # Read, then clear,  the signature
      signature = document.at("#{prefix}/ds:Signature", NS_MAP)
      signature.remove

      #TODO Verify the document digests to ensure that the document hasn't been modified (See gist.github.com/steffentchr/9036789)

      # Set up the certificate
      response_cert = original.at("#{prefix}/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509Certificate", NS_MAP).text
      decoded_cert = Base64.decode64(response_cert)
      certificate = OpenSSL::X509::Certificate.new(decoded_cert)

      # Canonicalization: Stringify the node in a nice way
      node = original.at("#{prefix}/ds:Signature/ds:SignedInfo", NS_MAP)
      canoned = node.canonicalize(C14N)

      # Figure out which method has been used to the sign the node
      signature_method = OpenSSL::Digest::SHA256
      if signature.at("./ds:SignedInfo/ds:SignatureMethod/@Algorithm", NS_MAP).text =~ /sha(\d+)$/
        signature_method = SHA_MAP[$1.to_i]
      end

      # Read the signature
      signature_value = signature.at("./ds:SignatureValue", NS_MAP).text
      decoded_signature_value = Base64.decode64(signature_value)

      # Finally, verify that the signature is correct
      verify = certificate.public_key.verify(signature_method.new, decoded_signature_value, canoned)
      if verify
        # sign in and redirect
        @user = User.from_omniauth(auth_hash, "saml")
        sign_in_and_redirect @user
      else
        raise "SAMLResponse signature incorrect\n"
      end
    end
  else
    def sba_idp
      @user = User.from_omniauth request.env['omniauth.auth']

      if @user.persisted?
        set_session @user
        sign_in @user
        set_up_contributor_if_needed(@user)
        flash[:info] = 'Logging in via SBA-IDP.'
        redirect_to after_sign_in_path_for(@user)
      else
        flash[:error] = 'Login Failed.'
        redirect_to root_path
      end
    end
  end

  private

  # this needs to move to user model?
  def decode_raw_saml_response(response)
    require "base64"
    if response =~ /^</
      return response
    elsif (decoded  = Base64.decode64(response)) =~ /^</
      return decoded
    elsif (inflated = inflate(decoded)) =~ /^</
      return inflated
    end
    raise "Couldn't decode SAMLResponse"
  end

  def auth_hash
    saml_response_base64 = params["SAMLResponse"]
    saml_response_hash = Hash.from_xml(decode_raw_saml_response(saml_response_base64).gsub("\n", ""))
    user_attributes_hash = saml_response_hash["Response"]["Assertion"]["AttributeStatement"]["Attribute"]
    return user_attributes_hash
  end
end
