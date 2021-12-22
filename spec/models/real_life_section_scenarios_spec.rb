require 'rails_helper'

RSpec.describe 'Given a basic questionnaire' do
  before do
    @questionnaire = create(:basic_questionnaire)
    @count = @questionnaire.every_section.count
  end

  it 'should have no sections' do
    expect(@count).to be_zero
  end

  context 'with some basic sections and rules' do
    before do
      @questionnaire.create_sections! do
        root 'rudi', 0 do
          question_section 'bill', 0, first: true
          question_section 'ted', 1
          review_section 'review', 2, title: 'Review It'
        end
      end

      @questionnaire.create_rules! do
        section_rule 'bill', 'ted'
        section_rule 'ted', 'review', expression: {totally: 'bogus'}
      end

      @first_section = @questionnaire.first_section
      @root_section  = @questionnaire.root_section
    end

    it "should have the proper sections created, arranged and ordered" do
      expect(@first_section.name).to eq('bill')
      expect(@root_section.arrangement).to eq([{
                name: 'rudi',
                title: 'Rudi',
                position: 0,
                type: 'root',
                questionnaire_id: @questionnaire.id,
                sba_application_id: nil,
                children: [
                    {
                        name: 'bill',
                        title: 'Bill',
                        position: 0,
                        type: 'question_section',
                        questionnaire_id: @questionnaire.id,
                        sba_application_id: nil,
                        children: []
                    },
                    {
                        name: 'ted',
                        title: 'Ted',
                        position: 1,
                        type: 'question_section',
                        questionnaire_id: @questionnaire.id,
                        sba_application_id: nil,
                        children: []
                    },
                    {
                        name: 'review',
                        title: 'Review It',
                        position: 2,
                        type: 'review_section',
                        questionnaire_id: @questionnaire.id,
                        sba_application_id: nil,
                        children: []
                    }
                ]
            }
        ])
      expect(@questionnaire.every_section.count).to eq(4)
      # root is not displayable
      expect(@questionnaire.every_section - @questionnaire.sections).to eq([@root_section])
    end

    it 'should have the proper section rules' do
      expect(@questionnaire.section_rules.map(&:debug)).to include("basic_q: bill => ted")
      expect(@questionnaire.section_rules.map(&:debug)).to include("basic_q: ted => review \n\twhen {\"expression\"=>{\"totally\"=>\"bogus\"}}")
      expect(@questionnaire.section_rules.count).to eq(2)
    end

    context 'creating an application' do
      before do
        @organization = create(:organization)
        @sba_application = @questionnaire.start_application @organization
        @sba_application.creator_id = 1
        @sba_application.save!
        @root_section = @sba_application.root_section
        @first_section = @sba_application.first_section
      end

      it 'should copy the sections for the application' do
        expect(@root_section.name).to eq('rudi')
        expect(@first_section.name).to eq('bill')
        expect(@root_section.arrangement).to eq([
            {
                 name: 'rudi',
                 title: 'Rudi',
                 position: 0,
                 type: 'root',
                 questionnaire_id: @questionnaire.id,
                 sba_application_id: @sba_application.id,
                 children: [
                     {
                         name: 'bill',
                         title: 'Bill',
                         position: 0,
                         type: 'question_section',
                         questionnaire_id: @questionnaire.id,
                         sba_application_id: @sba_application.id,
                         children: []
                     },
                     {
                         name: 'ted',
                         title: 'Ted',
                         position: 1,
                         type: 'question_section',
                         questionnaire_id: @questionnaire.id,
                         sba_application_id: @sba_application.id,
                         children: []
                     },
                     {
                         name: 'review',
                         title: 'Review It',
                         position: 2,
                         type: 'review_section',
                         questionnaire_id: @questionnaire.id,
                         sba_application_id: @sba_application.id,
                         children: []
                     }
                 ]
             }
        ])
        expect(@questionnaire.every_section.count).to eq(4)
        expect(@sba_application.every_section.count).to eq(4)
      end

      it 'should copy the section rules for the application' do
        #expect(@sba_application.section_rules.map(&:debug)).to include("basic_q (): bill => ted")
        #expect(@sba_application.section_rules.map(&:debug)).to include("basic_q (): ted => review \n\twhen {\"expression\"=>{\"totally\"=>\"bogus\"}}")
        expect(@sba_application.section_rules.count).to eq(2)
      end

      describe "questionnaire" do
        it 'should not have any of the application sections' do
          expect(@questionnaire.sections.where('sba_application_id IS NOT NULL').count).to be_zero
          expect(@questionnaire.every_section.where('sba_application_id IS NOT NULL').count).to be_zero
          expect(@questionnaire.templates.where('sba_application_id IS NOT NULL').count).to be_zero

          expect(@questionnaire.root_section.arrangement).to eq([
            {
                 name: 'rudi',
                 title: 'Rudi',
                 position: 0,
                 type: 'root',
                 questionnaire_id: @questionnaire.id,
                 sba_application_id: nil,
                 children: [
                     {
                         name: 'bill',
                         title: 'Bill',
                         position: 0,
                         type: 'question_section',
                         questionnaire_id: @questionnaire.id,
                         sba_application_id: nil,
                         children: []
                     },
                     {
                         name: 'ted',
                         title: 'Ted',
                         position: 1,
                         type: 'question_section',
                         questionnaire_id: @questionnaire.id,
                         sba_application_id: nil,
                         children: []
                     },
                     {
                         name: 'review',
                         title: 'Review It',
                         position: 2,
                         type: 'review_section',
                         questionnaire_id: @questionnaire.id,
                         sba_application_id: nil,
                         children: []
                     }
                 ]
            }
          ])
        end

        it 'should have the same section rules' do
          expect(@questionnaire.section_rules.map(&:debug)).to include("basic_q: bill => ted")
          expect(@questionnaire.section_rules.map(&:debug)).to include("basic_q: ted => review \n\twhen {\"expression\"=>{\"totally\"=>\"bogus\"}}")

          expect(@questionnaire.section_rules.where('sba_application_id IS NOT NULL').count).to be_zero
          expect(@questionnaire.every_section_rule.where('sba_application_id IS NOT NULL').count).to be_zero
          expect(@questionnaire.section_rule_templates.where('sba_application_id IS NOT NULL').count).to be_zero

          expect(@questionnaire.section_rules.count).to eq(2)
        end
      end
    end
  end
end
