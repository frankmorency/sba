require "rails_helper"

RSpec.describe SbaApplication::SimpleApplication, type: :model do
  it { is_expected.to belong_to(:questionnaire) }
  it { is_expected.to have_many(:workflow_changes) }
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to have_many(:every_section) }
  it { is_expected.to have_many(:dynamic_sections) }
  it { is_expected.to have_many(:section_spawners) }
  it { is_expected.to have_many(:sections) }
  it { is_expected.to have_many(:templates) }
  it { is_expected.to have_many(:every_section_rule) }
  it { is_expected.to have_many(:section_rules) }
  it { is_expected.to have_many(:section_rule_templates) }
  it { is_expected.to have_many(:current_answers) }
  it { is_expected.to have_many(:current_reviews) }
  it { is_expected.to have_many(:current_business_partners) }
  it { is_expected.to have_many(:current_sba_application_documents) }
  # it { is_expected.to have_many(:current_documents) }
  it { is_expected.to have_many(:current_sections) }
  it { is_expected.to have_many(:current_section_rules) }
  it { is_expected.to have_many(:answers) }
  it { is_expected.to have_many(:reviews) }
  it { is_expected.to have_many(:business_partners) }
  it { is_expected.to have_many(:sba_application_documents) }
  it { is_expected.to have_many(:documents) }
  it { is_expected.to belong_to(:current_sba_application) }
end
