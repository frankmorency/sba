require 'rails_helper'

RSpec.describe EligibleNaicCode, type: :model do
  it { is_expected.to belong_to(:certificate_type) }
end
