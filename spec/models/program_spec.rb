require 'rails_helper'

RSpec.describe Program, type: :model do
  it { is_expected.to have_many(:groups) }
  it { is_expected.to have_many(:questionnaires) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:name) }

end
