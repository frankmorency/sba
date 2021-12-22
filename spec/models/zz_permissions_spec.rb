require 'rails_helper'
require_relative '../permissions_helper'

RSpec.describe Permissions, type: :model do
  it { is_expected.to validate_presence_of(:user) }

  before do
    @users = {
        is_case_owner: create(:eight_a_user, roles: [FactoryBot.create(:sba_analyst_8a_cods_role)]),
        is_reviewer: create(:eight_a_user, roles: [FactoryBot.create(:sba_analyst_8a_cods_role)])
    }

    Permissions::ValidityMatrix::ROLES.each do |role|
      case role
        when :vendor_user, :contributor_user, :sba_supervisor_user
          @users[role] = create(role)
        else
          @users[role] = create(:eight_a_user, roles: [FactoryBot.create(:"#{role}_role")])
      end
    end

    @certificate = build(:certificate_eight_a)
    @app = create(:basic_application, organization: @certificate.organization)
    @certificate.sba_applications << @app
    @certificate.save!
    @review = Review::EightAInitial.create_and_assign_review(@users[:is_case_owner], @app)
  end

  after do
    @app.destroy!
    @certificate.destroy!
    @review.destroy!
  end

  describe "can_manage_agency_reqs?" do
    context "when vendor" do
      it 'should NOT have permission' do
        expect(Permissions.build(@users[:vendor_user]).can_manage_agency_reqs?).to be_falsey
      end
    end

    context "when contributor" do
      it 'should NOT have permission' do
        expect(Permissions.build(@users[:contributor_user]).can_manage_agency_reqs?).to be_falsey
      end
    end

    context "when other sba staff" do
      it 'should have permission' do
        expect(Permissions.build(@users[:sba_supervisor_user]).can_manage_agency_reqs?).to be_truthy
        expect(Permissions.build(@users[:sba_analyst_8a_cods]).can_manage_agency_reqs?).to be_truthy
      end
    end
  end

  Permissions::ValidityMatrix.load.permissions.each do |questionnaire, q_data|
    context "for #{questionnaire}" do
      q_data.each do |review_status, r_data|
        context "review in #{review_status}" do
          r_data.each do |perm, p_data|
            permission = :"#{perm}?"
            line = p_data[:line_number]

            describe "##{permission}\t\tL#{line}" do
              p_data.each do |role, stat|
                next if role == :line_number

                has_permission = !stat.blank?

                # TODO: CASE OWNER AND REVIEWER
                # TODO: FULL CSV
                context role do
                  subject { Permissions.build(@users[role], @review) }

                  it has_permission ? "should have permission" : "should NOT have permission" do
                    allow(subject).to receive(:review_status).and_return(review_status == :unassigned ? nil : review_status.to_s)
                    allow(subject).to receive(:is_reviewer?).and_return(role == :is_reviewer)
                    allow(subject).to receive(:is_case_owner?).and_return(role == :is_case_owner)

                    expect(subject.send(permission)).to eq(has_permission)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
