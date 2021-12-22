require 'rails_helper'

RSpec.describe SectionRule, type: :model do
  it { is_expected.to belong_to(:questionnaire) }
  it { is_expected.to belong_to(:sba_application) }
  it { is_expected.to belong_to(:from_section) }
  it { is_expected.to belong_to(:to_section) }
  it { is_expected.to belong_to(:template_root) }


end
