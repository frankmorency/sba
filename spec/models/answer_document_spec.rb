require 'rails_helper'

RSpec.describe AnswerDocument, type: :model do
  it { is_expected.to belong_to(:answer) }
  it { is_expected.to belong_to(:document) }
end
