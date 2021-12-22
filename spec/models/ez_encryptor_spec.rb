require 'rails_helper'

RSpec.describe EzEncryptor, type: :model do

  describe "#EzEncryptor" do
    it 'Encrypt the string and then decrypt it' do
      string = "Bruno Rocks when Encrypting and Decrypting String"
      enc = EzEncryptor.instance.encrypt(string)
      dec = EzEncryptor.instance.decrypt(enc)
      expect(string).to eq(dec)
    end

    it 'Splits the params after decrypting them' do
      string = "bruno=cool&rails=easy"
      enc = EzEncryptor.instance.encrypt(string)
      hash = EzEncryptor.instance.decrypt_and_split_params(enc)
      expect hash == {"bruno": "cool", "rails": "easy"}
    end

    it 'veryfy we do have a singleton' do 
      a = EzEncryptor.instance
      b = EzEncryptor.instance
      expect(a).to equal(b)
    end
  end
end
