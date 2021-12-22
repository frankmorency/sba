require 'rails_helper'

RSpec.describe DocumentTypeQuestion, type: :model do
  it { is_expected.to belong_to(:document_type) }
  it { is_expected.to belong_to(:question) }
end
