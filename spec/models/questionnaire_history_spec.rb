require 'rails_helper'

RSpec.describe QuestionnaireHistory, type: :model do
  it { is_expected.to belong_to(:questionnaire) }
  it { is_expected.to belong_to(:certificate_type) }
end
