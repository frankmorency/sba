require 'rails_helper'

RSpec.describe BusinessPartner, type: :model do
  it { is_expected.to belong_to(:sba_application) }
  it { is_expected.to have_many(:dynamic_sections) }
  it { is_expected.to have_many(:answers) }

  # TODO: Revisit when I have more time
  # describe "#full_name" do
  #   before do
  #     SbaApplication.any_instance.stub(copy_sections_and_rules: true)
  #     @business_partner = create(:business_partner)
  #     @new_business_partner = build(:business_partner)
  #     @new_business_partner.valid?
  #   end
  #
  #   it 'must be unique' do
  #     expect(@new_business.errors.full_messages).to include("asdfasdf")
  #   end
  # end
end
