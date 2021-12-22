require 'rails_helper'
include ActionDispatch::TestProcess

RSpec.describe S3Service, type: :model do
  describe "#upload_file" do

    before do
      @bucket_name = 'sba-docs-dev'
      @invalid_bucket_name = 'sba-docs-nonexistent'
      @file_identifier = 'uploaded.pdf'
      @file_content = File.open("#{Rails.root}/spec/fixtures/files/valid.pdf", "r"){ |file| file.read }
    end

    context "when bucket doesn't exist" do
      # it "returns false" do
    	 #  expect(S3Service.new.upload_file(@invalid_bucket_name, @file_identifier, @file_content)).to eq(false)
      # end
    end

    context "when file is successfully uploaded" do
      # it "returns true" do
    	 #  expect(S3Service.new.upload_file(@bucket_name, @file_identifier, @file_content)).to eq(true)
      # end
    end

  end  
end