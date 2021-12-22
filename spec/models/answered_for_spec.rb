require 'rails_helper'

RSpec.describe AnsweredFor, type: :model do

  describe "#factory" do
    context "when provided no answered for keys" do
      it 'should return nil' do
        expect(AnsweredFor.factory(nil, {})).to be_nil
      end
    end

    context "when provided a valid answered for class" do
      before do
        @partner = BusinessPartner.new(id: 1, sba_application_id: 66)

        @data = {'answered_for_type' => "BusinessPartner", 'answered_for_id' => '1'}
      end

      context "without the right application" do
        it 'should raise a data manipulation error' do
          expect(BusinessPartner).to receive(:find).with('1').and_return @partner
          expect {
            AnsweredFor.factory(11, @data)
          }.to raise_error(Error::DataManipulation)
        end
      end

      it 'should find the instance of that class' do
        expect(BusinessPartner).to receive(:find).with('1').and_return @partner
        AnsweredFor.factory(66, @data)
      end
    end

    context "when provided an invalid answered for class" do
      before do
        @data = {'answered_for_type' => "System", 'answered_for_id' => 'rm -rf *'}
      end

      it 'should return nil' do
        expect(AnsweredFor.factory(nil, @data)).to be_nil
      end

      it 'should not call constantize' do
        expect_any_instance_of(String).not_to receive(:constantize)
        AnsweredFor.factory(nil, @data)
      end
    end
  end
end
