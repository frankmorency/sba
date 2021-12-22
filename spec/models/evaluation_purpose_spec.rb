require 'rails_helper'

RSpec.describe EvaluationPurpose, type: :model do
  it { is_expected.to belong_to(:certificate_type) }
  it { is_expected.to belong_to(:questionnaire) }
  it { is_expected.to have_many(:applicable_questions) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
