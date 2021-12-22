require 'rails_helper'

RSpec.describe ApplicationStatusType, type: :model do
  it { is_expected.to have_many(:sba_applications) }
end
