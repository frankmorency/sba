require 'rails_helper'

RSpec.describe DocumentType, type: :model do
  it { is_expected.to have_many(:documents) }
end
