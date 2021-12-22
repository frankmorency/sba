require 'rails_helper'

RSpec.describe SbaApplication::SimpleApplication, type: :model do
  describe "#workflow_spec" do
    it 'should have the right states' do
      expect(SbaApplication::SimpleApplication.workflow_spec.state_names).to eq([:draft, :submitted, :under_review, :complete, :inactive])
    end
  end
end

RSpec.describe SbaApplication::SubApplication, type: :model do
  describe "#workflow_spec" do
    it 'should be the bare minimum' do
      expect(SbaApplication::SubApplication.workflow_spec.state_names).to eq([:draft, :submitted, :appeal_intent_selected])
    end
  end
end

RSpec.describe SbaApplication::EightAMaster, type: :model do
  describe "#workflow_spec" do
    it 'should have the right states' do
      expect(SbaApplication::EightAMaster.workflow_spec.state_names).to eq([:draft, :submitted, :under_review, :complete, :inactive, :returned])
    end
  end
end
