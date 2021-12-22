require 'rails_helper'

RSpec.describe Section::Spawner, type: :model do
  it { is_expected.to belong_to(:template) }
  it { is_expected.to validate_presence_of(:repeat) }
  it { is_expected.to validate_presence_of(:template) }

  describe '#class_path' do
    it 'should be "spawners"' do
      expect(Section::Spawner.new.class_path).to eq('spawners')
    end
  end

  describe "#first_rule" do

  end

  describe "#last_rule" do

  end

  context 'A questionnaire with a template' do
    before do
      @organization = create(:org_with_user)
      @user = @organization.users.first
      ActiveRecord::Base.connection.execute("INSERT INTO sam_organizations(duns, tax_identifier_number, tax_identifier_type, sam_extract_code,
        legal_business_name) VALUES ('#{@organization.duns_number}', '#{@organization.tax_identifier}', '#{@organization.tax_identifier_type}', 'A', 'The Firm');")
      MvwSamOrganization.refresh
      @questionnaire = create(:basic_questionnaire)

      @evaluation_purpose = @questionnaire.evaluation_purposes.create! name: 'eval_purp', certificate_type: @questionnaire.certificate_type

      @template = @questionnaire.create_sections! do
        template 'owners', 0, title: 'Owner {value}', displayable: false do
          template 'sec_1', 0, title: 'First Section {value}' do
            yesno 'sec_1_question_1', 0, positive_response: {eval_purp: 'yes'}, helpful_info: {default: 'words'}
            yesno 'sec_1_question_2', 1, positive_response: {eval_purp: 'yes'}, helpful_info: {default: 'words'}
          end
          template 'sec_2', 1 do
            yesno 'sec_2_question_1', 0, positive_response: {eval_purp: 'no'}, helpful_info: {default: 'words'}
          end
        end
      end

      @questionnaire.create_sections! do
        root 'da_root', 0 do
          spawner 'spawny', 0, first: true, template_name: 'owners', repeat: { name: 'Owner {value}', model: 'BusinessPartner', starting_position: 1, next_section: 'review' } do
            yesno 'first_question', 0, positive_response: {eval_purp: 'yes'}, helpful_info: {default: 'words'}
            owner_list 'owners', 1, title: 'Who are the owners?', decider: true, helpful_info: {default: 'words'}
          end
          review_section 'review', 100, title: 'Review It'
        end
      end

      @questionnaire.create_rules! do
        template_rules 'owners' do
          section_rule nil, 'sec_1'
          section_rule 'sec_1', 'sec_2'
          section_rule 'sec_2', nil
        end

        r = section_rule 'spawny', 'review'
        r.update_attribute(:is_last, true)
      end
    end

    # pre application state
    describe "the questionnaire's section rules" do
      before do
        @section_rules = @questionnaire.section_rules
        @every_section_rule = @questionnaire.every_section_rule
        @section_rule_templates = @questionnaire.section_rule_templates
      end

      it 'should be setup with separate template rules and normal section rules' do
        expect(@section_rules.map(&:debug)).to eq(['basic_q: spawny => review'])

        expect(@section_rule_templates.map(&:debug)).to include('basic_q:  => sec_1 [owners]')
        expect(@section_rule_templates.map(&:debug)).to include('basic_q: sec_1 => sec_2 [owners]')
        expect(@section_rule_templates.map(&:debug)).to include('basic_q: sec_2 =>  [owners]')
        expect(@section_rule_templates.count).to eq(3)

        expect(@every_section_rule.map(&:debug)).to include('basic_q: spawny => review')
        expect(@every_section_rule.map(&:debug)).to include('basic_q:  => sec_1 [owners]')
        expect(@every_section_rule.map(&:debug)).to include('basic_q: sec_1 => sec_2 [owners]')
        expect(@every_section_rule.map(&:debug)).to include('basic_q: sec_2 =>  [owners]')
        expect(@every_section_rule.count).to eq(4)
      end
    end

    # post application state / pre answer state
    context 'starting an application' do
      before do
        @original_section_rules = @questionnaire.section_rules
        @original_every_section_rule = @questionnaire.every_section_rule
        @original_section_rule_templates = @questionnaire.section_rule_templates

        @sba_application = @questionnaire.start_application(@organization)
        @sba_application.creator_id = 1
        @sba_application.save!
        @root_section, @first_section = @sba_application.root_section, @sba_application.first_section

        # starting_position: 1, model: 'BusinessPartner', next_section: 'review', decider: 'owners'
        @spawner = @sba_application.sections.get('spawny')
        @end_section = @sba_application.sections.get('review')

        @section_rules = @sba_application.section_rules.reload
        @every_section_rule = @sba_application.every_section_rule.reload
        @section_rule_templates = @sba_application.section_rule_templates.reload
      end

      describe '#template' do
        before do
          @template = @sba_application.templates.get('owners')
        end

        it 'should be the one copied for the application' do
          expect(@spawner.template).to eq(@template)
        end
      end

      describe '#template_rules' do
        before do
          @rules = @spawner.template_rules
        end

        it 'should include all rules with template as the template root for this application' do
          expect(@rules.map(&:debug)).to include('basic_q (The Firm):  => sec_1 [owners]')
          expect(@rules.map(&:debug)).to include('basic_q (The Firm): sec_1 => sec_2 [owners]')
          expect(@rules.map(&:debug)).to include('basic_q (The Firm): sec_2 =>  [owners]')
          expect(@rules.count).to eq(3)
        end
      end

      describe '#decision_question' do
        it 'should be defined by the repeat attribute json' do
          expect(@spawner.decision_question.name).to eq('owners')
        end
      end

      describe "the questionnaire's section rules shouldn't change" do
        it 'should be setup with separate template rules and normal section rules' do
          expect(@questionnaire.section_rules).to eq(@original_section_rules)
          expect(@questionnaire.section_rule_templates).to eq(@original_section_rule_templates)
          expect(@questionnaire.every_section_rule).to eq(@original_every_section_rule)
        end
      end

      describe "the application's section rules" do
        it 'should look just like the questionnaires' do
          expect(@section_rules.map(&:debug)).to eq(['basic_q (The Firm): spawny => review'])

          expect(@every_section_rule.count).to eq(4)
          expect(@every_section_rule.map(&:debug)).to include('basic_q (The Firm): spawny => review')
          expect(@every_section_rule.map(&:debug)).to include('basic_q (The Firm):  => sec_1 [owners]')
          expect(@every_section_rule.map(&:debug)).to include('basic_q (The Firm): sec_1 => sec_2 [owners]')
          expect(@every_section_rule.map(&:debug)).to include('basic_q (The Firm): sec_2 =>  [owners]')

          expect(@section_rule_templates.count).to eq(3)
          expect(@section_rule_templates.map(&:debug)).to include('basic_q (The Firm):  => sec_1 [owners]')
          expect(@section_rule_templates.map(&:debug)).to include('basic_q (The Firm): sec_1 => sec_2 [owners]')
          expect(@section_rule_templates.map(&:debug)).to include('basic_q (The Firm): sec_2 =>  [owners]')
        end
      end

      describe 'dynamic sections' do
        it 'should not exist' do
          expect(@sba_application.sections.where(dynamic: true).count).to be_zero
        end
      end

      describe 'sec_1 of the questionnaire' do
        it 'should be spawner' do
          expect(@sba_application.first_section).to eq(@spawner)
        end
      end

      describe 'all the sections' do
        before do
          @tree = @sba_application.root_section.arrangement
          @template_tree = @sba_application.templates.first.arrangement
        end

        it 'should be copied for this application and properly arranged' do
          expect(@tree).to eq([{
                                   name: 'da_root',
                                   title: 'Da Root',
                                   position: 0,
                                   type: 'root',
                                   questionnaire_id: @questionnaire.id,
                                   sba_application_id: @sba_application.id,
                                   children: [
                                       {
                                           name: 'spawny',
                                           title: 'Spawny',
                                           position: 0,
                                           type: 'spawner',
                                           questionnaire_id: @questionnaire.id,
                                           sba_application_id: @sba_application.id,
                                           children: []
                                       },
                                       {
                                           name: 'review',
                                           title: 'Review It',
                                           position: 100,
                                           type: 'review_section',
                                           questionnaire_id: @questionnaire.id,
                                           sba_application_id: @sba_application.id,
                                           children: []
                                       }
                                   ]
                               }])

          expect(@sba_application.templates.count).to eq(1)

          expect(@template_tree).to eq([{
                                            name: 'owners',
                                            title: 'Owner {value}',
                                            position: 0,
                                            type: 'template',
                                            questionnaire_id: @questionnaire.id,
                                            sba_application_id: @sba_application.id,
                                            children: [
                                                {
                                                    name: 'sec_1',
                                                    title: 'First Section {value}',
                                                    position: 0,
                                                    type: 'template',
                                                    questionnaire_id: @questionnaire.id,
                                                    sba_application_id: @sba_application.id,
                                                    children: []
                                                },
                                                {
                                                    name: 'sec_2',
                                                    title: 'Sec 2',
                                                    position: 1,
                                                    type: 'template',
                                                    questionnaire_id: @questionnaire.id,
                                                    sba_application_id: @sba_application.id,
                                                    children: []
                                                }
                                            ]
                                        }])

          expect(@sba_application.root_section.name).to eq(@questionnaire.root_section.name)
          expect(@sba_application.root_section.children.count).to eq(2)
          expect(@sba_application.root_section.children.order('position asc').first).to eq(@spawner)
          expect(@sba_application.root_section.children.order('position asc').last).to eq(@end_section)
        end

        it 'should not include the template section' do
          expect(@sba_application.sections).not_to include(@template)
        end
      end

      # post answer state
      context 'answering the spawner section' do
        before do
          @original_template_tree = @sba_application.templates.first.arrangement

          @answer = [
              {
                  first_name: 'Mike',
                  last_name: 'Cowden',
                  title: 'Owner',
                  marital_status: 'Unmarried',
                  ssn: '212-12-1212',
                  address: '12 Main St',
                  city: 'Baltimore',
                  state: 'MD',
                  postal_code: '21222',
                  home_phone: '232-123-1233',
                  business_phone: '232-123-1233',
                  email: 'mc@yahoo.com',
                  country: 'USA',
                  id: nil
              },
              {
                  first_name: 'Professor',
                  last_name: 'Pravin',
                  title: 'President',
                  marital_status: 'Married',
                  ssn: '212-12-1212',
                  address: '12 Main St',
                  city: 'Baltimore',
                  state: 'MD',
                  postal_code: '21222',
                  home_phone: '232-123-1233',
                  business_phone: '232-123-1233',
                  email: 'mc@yahoo.com',
                  country: 'USA',
                  id: nil
              }
          ]

          expect(@sba_application).to receive(:business_partners).at_least(:twice).and_call_original
          expect(BusinessPartner).not_to receive(:find_by)
          expect(BusinessPartner).not_to receive(:find)
          brand_new_answered_for_ids, old_format = BusinessPartner.from_params(@sba_application, @answer)

          @answer_params = answer_params(@spawner, 'no', old_format)
          @user.set_answers @answer_params, sba_application: @sba_application, section: @spawner,brand_new_answered_for_ids: brand_new_answered_for_ids

          @tree = @sba_application.root_section.arrangement
        end

        describe 'the section rules' do
          before do
            @section_rules = @sba_application.section_rules.reload
          end

          it 'should be updated to reflect the dynamic sections' do
            expect(@section_rules.map(&:debug)).to include('basic_q (The Firm): spawny => sec_1_mike_cowden')
            expect(@section_rules.map(&:debug)).to include('basic_q (The Firm): sec_1_mike_cowden => sec_2_mike_cowden')
            expect(@section_rules.map(&:debug)).to include('basic_q (The Firm): sec_2_mike_cowden => sec_1_professor_pravin')
            expect(@section_rules.map(&:debug)).to include('basic_q (The Firm): sec_1_professor_pravin => sec_2_professor_pravin')
            expect(@section_rules.map(&:debug)).to include('basic_q (The Firm): sec_2_professor_pravin => review')
            expect(@section_rules.count).to eq(5)
          end
        end

        describe 'the template rules' do
          it 'should remain unchanged' do
            expect(@sba_application.section_rule_templates).to eq(@section_rule_templates)
          end
        end

        # it 'should eventually allow for proper ordering of sections in the tree rather than just keep incrementing the index'

        describe 'the template sections' do
          it 'should not change' do
            expect(@sba_application.templates.count).to eq(1)
            expect(@sba_application.templates.first.arrangement).to eq(@original_template_tree)
          end
        end

        describe 'the section hierarchy' do
          it 'should now include the dynamic sections, properly arranged' do
            expect(@tree).to eq([{
                                     name: 'da_root',
                                     title: 'Da Root',
                                     position: 0,
                                     type: 'root',
                                     questionnaire_id: @questionnaire.id,
                                     sba_application_id: @sba_application.id,
                                     children: [
                                         {
                                             name: 'spawny',
                                             title: 'Spawny',
                                             position: 0,
                                             type: 'spawner',
                                             questionnaire_id: @questionnaire.id,
                                             sba_application_id: @sba_application.id,
                                             children: [
                                                 {
                                                     name: 'owners_mike_cowden',
                                                     title: 'Owner Mike Cowden',
                                                     position: 1, # after the starting position
                                                     type: 'question_section',
                                                     questionnaire_id: @questionnaire.id,
                                                     sba_application_id: @sba_application.id,
                                                     children: [
                                                         {
                                                             name: 'sec_1_mike_cowden',
                                                             title: 'First Section Mike Cowden',
                                                             position: 0,
                                                             type: 'question_section',
                                                             questionnaire_id: @questionnaire.id,
                                                             sba_application_id: @sba_application.id,
                                                             children: []
                                                         },
                                                         {
                                                             name: 'sec_2_mike_cowden',
                                                             title: 'Sec 2',
                                                             position: 1,
                                                             type: 'question_section',
                                                             questionnaire_id: @questionnaire.id,
                                                             sba_application_id: @sba_application.id,
                                                             children: []
                                                         }
                                                     ]
                                                 },
                                                 {
                                                     name: 'owners_professor_pravin',
                                                     title: 'Owner Professor Pravin',
                                                     position: 2,
                                                     type: 'question_section',
                                                     questionnaire_id: @questionnaire.id,
                                                     sba_application_id: @sba_application.id,
                                                     :children => [
                                                         {
                                                             name: 'sec_1_professor_pravin',
                                                             title: 'First Section Professor Pravin',
                                                             position: 0,
                                                             type: 'question_section',
                                                             questionnaire_id: @questionnaire.id,
                                                             sba_application_id: @sba_application.id,
                                                             children: []
                                                         },
                                                         {
                                                             name: 'sec_2_professor_pravin',
                                                             title: 'Sec 2',
                                                             position: 1,
                                                             type: 'question_section',
                                                             questionnaire_id: @questionnaire.id,
                                                             sba_application_id: @sba_application.id,
                                                             children: []
                                                         }
                                                     ]
                                                 }
                                             ]
                                         },
                                         {
                                             name: 'review',
                                             title: 'Review It',
                                             position: 100,
                                             type: 'review_section',
                                             questionnaire_id: @questionnaire.id,
                                             sba_application_id: @sba_application.id,
                                             children: []
                                         }
                                     ]
                                 }])
          end
        end

        # TODO: test transition to from the last dynamic section to end section...
        describe 'next_section' do
          before do
            @next_section, @skip_info = @sba_application.advance!(@user, @spawner, @answer_params)
          end

          it 'should be the first dynamic section' do
            expect(@next_section.title).to eq('First Section Mike Cowden')
          end
        end

        context 'and then renaming, adding and deleting one of them (at the same time)' do
          before do
            @original_template_tree = @sba_application.templates.first.arrangement
            @mike = @sba_application.business_partners.find_by(first_name: 'Mike', last_name: 'Cowden')
            @pravin = @sba_application.business_partners.find_by(first_name: 'Professor', last_name: 'Pravin')
            @answer = [
                {
                    first_name: 'Mark',
                    last_name: 'Cowden',
                    title: 'Owner',
                    marital_status: 'Unmarried',
                    ssn: '212-12-1212',
                    address: '12 Main St',
                    city: 'Baltimore',
                    state: 'MD',
                    postal_code: '21222',
                    country: 'USA',
                    home_phone: '232-123-1233',
                    business_phone: '232-123-1233',
                    email: 'mc@yahoo.com',
                    id: @mike.id
                },
                {
                    first_name: 'New',
                    last_name: 'Guy',
                    title: 'President',
                    id: nil,
                    marital_status: 'Married',
                    ssn: '212-12-1212',
                    address: '12 Main St',
                    city: 'Baltimore',
                    state: 'MD',
                    postal_code: '21222',
                    country: 'USA',
                    home_phone: '232-123-1233',
                    business_phone: '232-123-1233',
                    email: 'mc@yahoo.com'
                }
            ]


            brand_new_answered_for_ids, old_format = BusinessPartner.from_params(@sba_application, @answer)

            @answer_params = answer_params(@spawner, 'no', old_format)
            @user.set_answers @answer_params, sba_application: @sba_application, section: @spawner,brand_new_answered_for_ids: brand_new_answered_for_ids

            @tree = @sba_application.root_section.reload.arrangement
          end

          describe 'the section rules' do
            before do
              @section_rules = @sba_application.section_rules.reload
            end

            it 'should be updated to reflect the name change, delete and addition' do
              expect(@section_rules.map(&:debug)).to include('basic_q (The Firm): spawny => sec_1_mark_cowden')
              expect(@section_rules.map(&:debug)).to include('basic_q (The Firm): sec_1_mark_cowden => sec_2_mark_cowden')
              expect(@section_rules.map(&:debug)).to include('basic_q (The Firm): sec_2_mark_cowden => sec_1_new_guy')
              expect(@section_rules.map(&:debug)).to include('basic_q (The Firm): sec_1_new_guy => sec_2_new_guy')
              expect(@section_rules.map(&:debug)).to include('basic_q (The Firm): sec_2_new_guy => review')
              expect(@section_rules.count).to eq(5)
            end
          end

          describe 'the template rules' do
            it 'should remain unchanged' do
              expect(@sba_application.section_rule_templates).to eq(@section_rule_templates)
            end
          end

          # it 'should eventually allow for proper ordering of sections in the tree rather than just keep incrementing the index'

          describe 'the template sections' do
            it 'should not change' do
              expect(@sba_application.templates.count).to eq(1)
              expect(@sba_application.templates.first.arrangement).to eq(@original_template_tree)
            end
          end

          describe 'the section hierarchy' do
            it 'should now include the dynamic sections, properly arranged' do
              expect(@tree).to eq([{
                                       name: 'da_root',
                                       title: 'Da Root',
                                       position: 0,
                                       type: 'root',
                                       questionnaire_id: @questionnaire.id,
                                       sba_application_id: @sba_application.id,
                                       children: [
                                           {
                                               name: 'spawny',
                                               title: 'Spawny',
                                               position: 0,
                                               type: 'spawner',
                                               questionnaire_id: @questionnaire.id,
                                               sba_application_id: @sba_application.id,
                                               children: [
                                                   {
                                                       name: 'owners_mark_cowden',
                                                       title: 'Owner Mark Cowden',
                                                       position: 1, # after the starting position
                                                       type: 'question_section',
                                                       questionnaire_id: @questionnaire.id,
                                                       sba_application_id: @sba_application.id,
                                                       children: [
                                                           {
                                                               name: 'sec_1_mark_cowden',
                                                               title: 'First Section Mark Cowden',
                                                               position: 0,
                                                               type: 'question_section',
                                                               questionnaire_id: @questionnaire.id,
                                                               sba_application_id: @sba_application.id,
                                                               children: []
                                                           },
                                                           {
                                                               name: 'sec_2_mark_cowden',
                                                               title: 'Sec 2',
                                                               position: 1,
                                                               type: 'question_section',
                                                               questionnaire_id: @questionnaire.id,
                                                               sba_application_id: @sba_application.id,
                                                               children: []
                                                           }
                                                       ]
                                                   },
                                                   {
                                                       name: 'owners_new_guy',
                                                       title: 'Owner New Guy',
                                                       position: 2,
                                                       type: 'question_section',
                                                       questionnaire_id: @questionnaire.id,
                                                       sba_application_id: @sba_application.id,
                                                       :children => [
                                                           {
                                                               name: 'sec_1_new_guy',
                                                               title: 'First Section New Guy',
                                                               position: 0,
                                                               type: 'question_section',
                                                               questionnaire_id: @questionnaire.id,
                                                               sba_application_id: @sba_application.id,
                                                               children: []
                                                           },
                                                           {
                                                               name: 'sec_2_new_guy',
                                                               title: 'Sec 2',
                                                               position: 1,
                                                               type: 'question_section',
                                                               questionnaire_id: @questionnaire.id,
                                                               sba_application_id: @sba_application.id,
                                                               children: []
                                                           }
                                                       ]
                                                   }
                                               ]
                                           },
                                           {
                                               name: 'review',
                                               title: 'Review It',
                                               position: 100,
                                               type: 'review_section',
                                               questionnaire_id: @questionnaire.id,
                                               sba_application_id: @sba_application.id,
                                               children: []
                                           }
                                       ]
                                   }])
            end
          end

          # TODO: test transition to from the last dynamic section to end section...
          describe 'next_section' do
            before do
              @next_section, @skip_info = @sba_application.advance!(@user, @spawner, @answer_params)
            end

            it 'should be the first dynamic section' do
              expect(@next_section.title).to eq('First Section Mark Cowden')
            end
          end

          context 'and then finishing the application' do
            before do
              @next_section, @skip_info = @sba_application.advance!(@user, @spawner, @answer_params)
              @next_section, @skip_info = @sba_application.advance!(@user, @next_section, {})
              @next_section, @skip_info = @sba_application.advance!(@user, @next_section, {})
              @next_section, @skip_info = @sba_application.advance!(@user, @next_section, {})
              @next_section, @skip_info = @sba_application.advance!(@user, @next_section, {})
              @sba_application.send(:remove_nonapplicable_answers_and_sections, @user)
            end

            it 'should have answered all the sections' do
              expect(@sba_application).to be_answered_every_section
            end

            context 'and then creating the certificate' do
              before do
                allow(Signature).to receive(:new).and_return(Struct.new(:terms).new(Array.wrap(SignatureTerm.new("you will abide by my rulez"))))
                @sba_application.current_user = @user
                @certificate = @sba_application.submit!
                @certificate.valid?
              end

              it 'should be a valid cert' do
                expect(@certificate).to be_valid_certificate
                expect(@certificate.errors.full_messages).to be_blank
              end

              context 'and associating it to the application' do
                before do
                  @sba_application.certificate_id = @certificate.id
                  @sba_application.save!
                end

                context 'and then copying the application' do
                  before do
                    @new_version = @sba_application.return_for_modification

                    @new_tree = @new_version.root_section.reload.arrangement(false)
                    @new_section_rules = @new_version.section_rules
                  end


                  it 'should have the same sections as the original' do
                    expect(@new_tree).to eq(@sba_application.root_section.reload.arrangement(false))
                  end


                  it 'should have the same section rules as the original' do
                    expect(@new_section_rules.map(&:debug).sort).to eq(@sba_application.section_rules.reload.map(&:debug).sort)
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