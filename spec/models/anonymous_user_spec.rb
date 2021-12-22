require 'rails_helper'

RSpec.describe AnonymousUser, type: :model do
  it { is_expected.to have_many(:answers) }
end
