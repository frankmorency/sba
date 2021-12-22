require 'rails_helper'

RSpec.describe SbaApplication::Progress, type: :model do
  before do
    create_basic_app
  end

  describe "#advance!" do
    context 'trying to set progress on someone else\'s app' do
      before do
        @other_org = create(:organization, duns_number: '1234')
        @app.update_attribute(:organization_id, @other_org.id)
      end

      it 'should raise a data manipulation error' do
        expect {
          SbaApplication::Progress.advance! @app, @user, double("Section")
        }.to raise_error(Error::DataManipulation)
      end
    end
  end

  context 'with a single jump question: 11 -> 12 (11n) -> 21 (11y) -> 22 (answered yes)' do
    before do
      @answer = create(:answer_boolean, sba_application: @app, value: {'value' => 'yes'})

      @rule_11_12 = create(:section_rule, sba_application: @app,
                           questionnaire: @app.master,
                           from_section: @section11,
                           to_section: @section12,
                           expression: {
                               klass: 'Answer',
                               identifier: @answer.question.name,
                               value: 'no'
                           })

      @rule_11_21 = create(:section_rule,
                           sba_application: @app,
                           questionnaire: @app.master,
                           from_section: @section11,
                           to_section: @section21,
                           expression: {
                               klass: 'Answer',
                               identifier: @answer.question.name,
                               value: 'yes'
                           })

      @rule_12_21 = create(:section_rule,
                           sba_application: @app,
                           questionnaire: @app.master,
                           from_section: @section12,
                           to_section: @section21)

      @rule_21_22 = create(:section_rule,
                           sba_application: @app,
                           questionnaire: @app.master,
                           from_section: @section21,
                           to_section: @section22)
    end

    describe "#update_skip_info" do
      before do
        @app.update_skip_info! # normally done after the app is created, but... that step is deferred here for tests
      end

      it 'update all possible paths on a rule by rule basis' do
        expect(@rule_11_12.reload.skip_info).to eq({"notapplicable"=>[], "applicable"=>["section_1_2", "section_2_1", "section_2_2"]})
        expect(@rule_11_21.reload.skip_info).to eq({"notapplicable"=>["section_1_2"], "applicable"=>["section_2_1", "section_2_2"]})
        expect(@rule_12_21.reload.skip_info).to eq({"notapplicable"=>[], "applicable"=>["section_2_1", "section_2_2"]})
        expect(@rule_21_22.reload.skip_info).to eq({"notapplicable"=>[], "applicable"=>["section_2_2"]})
      end
    end
  end


  context 'with a multi-path question: 11 -> 12 (q12y) -> 21 (q21y) -> 22' do
    before do
      @answer12 = create(:answer_boolean, sba_application: @app, value: {'value' => 'yes'})
      @answer21 = create(:answer_boolean, sba_application: @app, value: {'value' => 'no'})

      @rule_11_multi = create(:section_rule, sba_application: @app,
                           questionnaire: @app.master,
                           from_section: @section11,
                           to_section: @section22,
                           expression: {
                               klass: 'MultiPath', rules: [
                                   {
                                       'section_1_2': {
                                           klass: 'Answer',
                                           identifier: @answer12.question.name,
                                           value: 'yes'
                                       }
                                   },
                                   {
                                       'section_2_1': {
                                           klass: 'Answer',
                                           identifier: @answer21.question.name,
                                           value: 'yes'
                                       }
                                   }
                               ]
                           })
    end

    describe "#update_skip_info" do
      before do
        @app.update_skip_info! # normally done after the app is created, but... that step is deferred here for tests
      end

      it 'update the paths so that each section is visited' do
        expect(@rule_11_multi.reload.skip_info).to eq({"notapplicable"=>[], "applicable"=>["section_2_2"]})
      end
    end
  end
end