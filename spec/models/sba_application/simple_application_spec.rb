# require 'rails_helper'

# RSpec.describe SbaApplication::SimpleApplication, type: :model do
#   before do
#     # replace this with inline creation
#     @certificate_type = load_sample_questionnaire('wosb')

#     # Create User and Org
#     i=200
#     @user = User.new(first_name: "John", last_name: "Last Name", email: "john@email.com", password: 'password1PASSWORD1!', password_confirmation: 'password1PASSWORD1!', confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
#     @user.organizations.new(duns_number: "DUNS123456_#{i}", tax_identifier: "EIN123456_#{i}", tax_identifier_type: 'EIN', business_type: 'llc')
#     @user.save!

#     # Create Application
#     @questionnaire = @certificate_type.initial_questionnaire
#     @organization = create(:org_with_user)
#     @user = @organization.users.first

#     ActiveRecord::Base.connection.execute("INSERT INTO sam_organizations(duns, tax_identifier_number, tax_identifier_type, sam_extract_code) VALUES ('#{@organization.duns_number}', '#{@organization.tax_identifier}', '#{@organization.tax_identifier_type}', 'A');")
#     MvwSamOrganization.refresh

#     @wosb_app = @questionnaire.start_application @user.one_and_only_org
#     @wosb_app.creator_id = 1
#     @wosb_app.save!

#     # Answer to questions
#     @wosb_8a_section = @wosb_app.sections.get("third_party_cert_part_2")
#     @wosb_sig_section = @wosb_app.sections.get("signature")
#     @wosb_oper6_section = @wosb_app.sections.get("operations_part_3")
#     q1_8a = @wosb_8a_section.question_presentations.get('tpc2_q1')
#     @oper6_q1 = @wosb_oper6_section.question_presentations.get('oper3_q1')
#     @oper6_q2 = @wosb_oper6_section.question_presentations.get('oper3_q2')
#     answer_params = {"#{q1_8a.id}"=>{value: "yes"}}
#     @user.set_answers answer_params, sba_application: @wosb_app
#     @user.save!
#     @wosb_app.advance!(@user, @wosb_8a_section, answer_params)
#   end

#   describe "#create" do
#     it "should be in Draft state" do
#       expect(@wosb_app).to be_draft
#     end

#     it 'should create a workflow state entry' do
#       expect(@wosb_app.workflow_changes.find_by(workflow_state: 'draft')).to_not be_nil
#     end

#     it 'should set decision correctly' do
#       expect(@wosb_app.decision).to eq('')
#     end

#     context 'when trying to create duplicate application' do
#       before do
#         @wosb_app = SbaApplication::SimpleApplication.new(organization: @user.one_and_only_org, questionnaire: @questionnaire, application_start_date: Time.now)
#       end

#       it "should not raise an error" do
#         expect(@wosb_app).not_to be_valid
#         expect(@wosb_app.errors[:application]).to include("already exists")
#       end
#     end
#   end

#   describe "#get_applicable_sections" do
#     before do
#       @section_list = @wosb_app.send(:get_applicable_sections)
#     end
    
#     context "sections" do
#       it 'should return applicable sections only' do
#         expect(@section_list).to include(@wosb_8a_section.for_app(@wosb_app), @wosb_sig_section.for_app(@wosb_app))
#       end

#       it 'should not include deferred sections' do
#         @deferrer = create(:section_deferrer, sba_application: @wosb_app, questionnaire: @questionnaire)
#         @deferred_section = create(:deferred_section, sba_application: @wosb_app, questionnaire: @questionnaire)
#         @deferred_section.update_attribute(:defer_applicability_for_id, @deferrer.id)

#         expect(@wosb_app.send(:get_applicable_sections).reload).not_to include(@deferred_section)
#         expect(@wosb_app.send(:get_applicable_sections)).to include(@deferrer)
#       end
#     end
#   end

#   describe "#get_deferred_sections" do
#     before do
#       @sections = double()
#       allow(@wosb_app).to receive(:sections).and_return(@sections)
#     end

#     it 'should only get the deferred sections' do
#       expect(@sections).to receive(:where).with('defer_applicability_for_id IS NOT NULL')
#       @wosb_app.send(:get_deferred_sections)
#     end
#   end

#   describe "#remove_unused_answers" do
#     before do
#       @extra_q = @wosb_app.sections.find_by(name: "tpc1").question_presentations.joins(:question).where("questions.name = 'tpc1_q1'").first

#       answer_params = {"#{@extra_q.id}"=>{value: "yes"}}
#       @wosb_app.sections.find_by(name: "tpc1").update({is_completed: true})
#       @user.set_answers answer_params, sba_application: @wosb_app
#       @user.save!
#     end

#     pending "ensure unused are removed" do
#       expect(@user.answers.count).to eq(2)
#       @wosb_app.send(:remove_nonapplicable_answers_and_sections, @user)
#       expect(@user.answers.count).to eq(1)
#     end
#   end

#   describe "#add_deferred_to_section_list" do
#     before do
#       allow(@wosb_app).to receive(:get_deferred_sections).and_return @deferred_sections
#     end

#     it 'should set' do

#     end
#   end

#   describe "#drafty?" do
#     before do
#       @app = SbaApplication::EightAMaster.new
#     end

#     context "when the app is in draft state" do
#       before do
#         @app.workflow_state = "draft"
#       end

#       it "should return true" do
#         expect(@app).to be_drafty
#       end
#     end

#     context "when the app is not in draft state" do
#       before do
#         @app.workflow_state = "submitted"
#       end

#       it "should return false" do
#         expect(@app).not_to be_drafty
#       end
#     end
#   end

#   describe "#answered_every_section?" do
#     before do
#       # Extra Answer
#       @extra_q = @wosb_app.sections.find_by(name: "operations_part_6").question_presentations.joins(:question).where("questions.name = 'oper6_q1'").first

#       answer_params = {"#{@extra_q.id}"=>{value: "yes"}}
#       @wosb_app.sections.find_by(name: "operations_part_6").update({is_completed: true})
#       @user.set_answers answer_params, sba_application: @wosb_app
#       @user.save!

#     end

#     context 'when questions are answered' do
#       pending 'should return true if all required questions answered' do

#         # Answer oper6 section
#         answer_params = {"#{@oper6_q1.id}"=>{value: "yes"}}
#         @user.set_answers answer_params, sba_application: @wosb_app
#         @user.save!
#         answer_params = {"#{@oper6_q2.id}"=>{value: "yes"}}
#         @user.set_answers answer_params, sba_application: @wosb_app
#         @user.save!

#         @wosb_app.advance!(@user, @wosb_oper6_section, answer_params)


#         @result = @wosb_app.answered_every_section?
#         expect(@result).to eq(true)
#       end

#       it 'should return false if all required questions not answered' do
#         expect(@wosb_app.answered_every_section?).to be_falsey
#       end
#     end
#   end

#   describe "#update_progress" do
#     it 'should update is_completed and is_applicable section for all relevant sections (and sub_sections_completed / sub_sections_applicable for parents)' do

#       @section = @wosb_app.sections.find_by_name('third_party_cert_part_2')

#       @next_section, @skip_info = @section.next_section(@user, @wosb_app.id)

#       progress = SbaApplication::Progress.new(@wosb_app)
#       progress.send(:update_progress, @section, @next_section, @skip_info)

#       expect(@wosb_app.sections.find_by({is_completed: true}).name).to eq("third_party_cert_part_2")

#       items=[]
#       @wosb_app.sections.where({is_applicable: false}).each do |sec|
#         items << sec.name
#       end

#       expect(items.sort).to eq(["corporation", "partnership"].sort)

#       items=[]
#       @wosb_app.sections.where({sub_sections_applicable: false}).each do |sec|
#         items << sec.name
#       end

#       expect(items.sort).to eq([])
#     end
#   end
# end

# RSpec.describe SbaApplication::SimpleApplication, type: :model do
#   describe "#signature_section" do
#     before do
#       @model = build(:persisted_application)
#     end

#     it 'should find the Signature Section for this application' do
#       expect(Section::SignatureSection).to receive(:find_by).with(sba_application_id: @model.id).and_return 4

#       expect(@model.signature_section).to eq(4)
#     end
#   end
# end
