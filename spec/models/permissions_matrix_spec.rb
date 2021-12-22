require 'rails_helper'
require_relative '../permissions_helper'

RSpec.describe Permissions::ValidityMatrix, type: :model do
  context 'given an invalid CSV file' do
    describe '.load' do
      it 'should raise meaningful errors' do
        expect { Permissions::ValidityMatrix.load('bad_questionnaire')}.to raise_error(/^Line 3.*flabberdoodle is not a valid questionnaire name/)
        expect { Permissions::ValidityMatrix.load('bad_review_state')}.to raise_error(/^Line 4.*whittling is not a valid review state/)
        expect { Permissions::ValidityMatrix.load('bad_perm')}.to raise_error(/^Line 2.*can_delete_database is not a valid permission/)
        expect { Permissions::ValidityMatrix.load('bad_role')}.to raise_error(/^Expected header \(sba_analyst_8a_district_office\) not found/)
        expect { Permissions::ValidityMatrix.load('bad_extra_head')}.to raise_error(/^Unexpected header.*probably_some_new_role_expected_to_work_like_magic/)
      end
    end
  end

  context 'given a valid CSV file' do
    before do
      @perms = Permissions::ValidityMatrix.load('baseline')
    end

    describe '#status' do
      it 'should return the proper value' do
        expect(@perms.status(:eight_a, :screening, :can_add_note, :sba_supervisor_user)).to be_truthy
        expect(@perms.status(:eight_a, :screening, :can_add_note, :vendor_user)).to be_falsey
      end
    end
  end
end