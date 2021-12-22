# Those long comments are for Andres ( I know he likes them )
# This is a simple encryptor Singleton Class that will be used to encrypt simple strings, such as url params.
# Everything is encoded base 64 URL SAFE ENCODED 
# 
# Note: since IV does not change the encypted values will always be the same for the same strings. To Acheive the best 
# security we would need to generate a diffrent IV for each pair ( enc/dec ) generated. 
# 
# In order to generate the secrets use:
#   - cipher = OpenSSL::Cipher.new('aes-256-gcm')
#   - cipher.encrypt                                                        # Required before '#random_key' or '#random_iv' can be called. http://ruby-doc.org/stdlib-2.0.0/libdoc/openssl/rdoc/OpenSSL/Cipher.html#method-i-encrypt
#   - secret_key = Base64.urlsafe_encode64( cipher.random_key )             # Insures that the key is the correct length respective to the algorithm used.
#   - iv = Base64.urlsafe_encode64( cipher.random_iv )                      # Insures that the IV is the correct length respective to the algorithm used.
#   - salt = Base64.urlsafe_encode64( SecureRandom.random_bytes(16) )
#
# or simply call the EzEncryptor.generate_secrets or the rake task: rake ez_encryptor:generate_secrets

require 'singleton'
require 'encryptor'
require 'base64'
require "rack"

class EzEncryptor
  include Singleton

  def initialize
    @secret_key = Base64.urlsafe_decode64(Settings.ez_encryptor.key_b64)
    @iv = Base64.urlsafe_decode64(Settings.ez_encryptor.iv_b64)
    @salt = Base64.urlsafe_decode64(Settings.ez_encryptor.salt_b64)
  end
  
  def encrypt(decrypted_message)
    encrypted_value = Encryptor.encrypt(value: decrypted_message, key: @secret_key, iv: @iv, salt: @salt)
    encrypted_value_b64 = Base64.urlsafe_encode64(encrypted_value)
    return encrypted_value_b64
  end

  def decrypt(encrypted_value_b64)
    encrypted_value = Base64.urlsafe_decode64(encrypted_value_b64)
    decrypted_value = Encryptor.decrypt(value: encrypted_value, key: @secret_key, iv: @iv, salt: @salt)
    return decrypted_value
  end

  def split_params(str)
    Rack::Utils.parse_query(str)
  end

  def decrypt_and_split_params(encrypted_value_b64)
    dec = decrypt(encrypted_value_b64)
    return split_params(dec)
  end

  class << self
    def generate_secrets(cypher_name='aes-256-gcm')
      cipher = OpenSSL::Cipher.new(cypher_name)
      cipher.encrypt
      secret_key = Base64.urlsafe_encode64( cipher.random_key )
      iv = Base64.urlsafe_encode64( cipher.random_iv )
      salt = Base64.urlsafe_encode64( SecureRandom.random_bytes(16) )

      return { secret_key_base64: secret_key, iv_base64: iv, salt_base64: salt }
    end
  end
end
