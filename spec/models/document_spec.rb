require 'rails_helper'
include ActionDispatch::TestProcess

RSpec.describe Document, type: :model do
  it { is_expected.to belong_to(:document_type) }
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to have_many(:answer_documents) }
  it { is_expected.to have_many(:answers).through(:answer_documents) }
  it { is_expected.to have_many(:sba_application_documents) }
  it { is_expected.to have_many(:sba_applications).through(:sba_application_documents) }

  before do
      dt = DocumentType.create! name: "Third Party Certification"
      @organization = create(:organization)
      @question = QuestionType.find_by(name: 'yesno').questions.first
      @answer = Answer.create!(response: {2=>{value: "yes"}}, question: @question)
  	  @document1 = Document.create!(organization_id: @organization.id, stored_file_name: Time.now.to_i.to_s, original_file_name: 'valid.pdf', document_type: dt, is_active: true, user_id: 1)
  	  @document2 = Document.create!(organization_id: @organization.id, stored_file_name: Time.now.to_i.to_s, original_file_name: 'valid.pdf', document_type: dt, is_active: true, user_id: 1)
  	  @document3 = Document.create!(organization_id: @organization.id, stored_file_name: Time.now.to_i.to_s, original_file_name: 'valid.pdf', document_type: dt, is_active: true, user_id: 1)
  	  @id1 = @document1.id
  	  @id2 = @document2.id
  	  @id3 = @document3.id  	  
      @valid_pdf = fixture_file_upload("#{Rails.root}/spec/fixtures/files/valid.pdf", 'application/pdf')
      @invalid_pdf = fixture_file_upload("#{Rails.root}/spec/fixtures/files/IMG_0260.pdf", 'image/png')
  end

  describe ".is_pdf?" do
    context "when given a valid PDF document" do
      it "returns true " do
    	  expect(Document.is_pdf?(@valid_pdf)).to eq(true)
      end    	
    end
    context "when given a non-PDF document" do
      it "returns false" do
    	  expect(Document.is_pdf?(@invalid_pdf)).to eq(false)
      end    	
    end    
  end

  describe ".make_association" do
  	before do
      Document.make_association(@answer, [@id1,@id2,@id3])
  	end
  	context "when given existing documents to associate to a model" do
  		it "associates the documents to the model" do
  		  expect(@answer.document_ids.sort).to eq([@id1, @id2, @id3].sort) 			
  		end
  	end
  end

  describe ".destroy_answer_document_associations" do
  	before do
      Document.make_association(@answer, [@id1,@id2,@id3])
      Document.destroy_answer_document_associations(@answer.id, [@id1,@id2,@id3])
  	end
  	context "when documents are removed from an answer" do
  		it "destroys the association between the documents and answer" do
  		  expect(@answer.document_ids.sort).not_to eq([@id1, @id2, @id3].sort)
  		end
  	end
  end

  describe ".upload_document" do
    context "when given a document" do
      # it "uploads a document to s3" do
    	 #  expect(Document.upload_document(@organization.folder_name, @valid_pdf, '1450373006')).to eq(true)
      # end
    end
  end

  describe ".file_key" do
    it "does not raise_error" do
      expect{@document1.file_key}.to_not raise_error(NotImplementedError)
    end

    it "returns 'organization.folder_name/stored_file_name'" do
      file_key = "#{@document1.organization.folder_name}/#{@document1.stored_file_name}"
      expect(@document1.file_key).to eq(file_key)
    end
  end
end