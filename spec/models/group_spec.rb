require 'rails_helper'

RSpec.describe Group, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:name) }

end
