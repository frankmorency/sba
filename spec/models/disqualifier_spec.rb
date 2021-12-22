require 'rails_helper'

RSpec.describe Disqualifier, type: :model do
  it { is_expected.to have_many(:question_presentations) }
  it { is_expected.to validate_presence_of(:value) }
  it { is_expected.to validate_presence_of(:message) }
end

