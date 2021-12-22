require 'rails_helper'

RSpec.describe ReviewDocument, type: :model do
  it { is_expected.to belong_to(:review) }
  it { is_expected.to belong_to(:document) }
end
