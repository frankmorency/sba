require 'rails_helper'

RSpec.describe QuestionnaireDSL, type: :model do
  context 'Given a questionnaire' do
    before do
      @questionnaire = Questionnaire.find_by(name: 'basic_q') || create(:basic_questionnaire)
    end

    context 'when given a single root' do
      before do
        @root = @questionnaire.create_sections! do
          root 'mike', 0
        end
      end

      it 'should setup that single section' do
        expect(@root.title).to eq('Mike')
        expect(@root.name).to eq('mike')
        expect(@root.parent).to be_nil
        expect(@root.children).to be_empty
        expect(@root.questionnaire).to eq(@questionnaire)
        expect(@root.position).to eq(0)
        expect(@root).to be_persisted
      end
    end

    context 'when given a more complex hierarchy' do
      before do
        @template = @questionnaire.create_sections! do
          template 'simple_template', 0
        end

        @root = @questionnaire.create_sections! do
          root 'roto_rooter', 0 do
            spawner 'section_one', 0, first: true, template_name: 'simple_template', repeat: {title: 'Stuff {value}'}
            question_section 'section_two', 1 do
              question_section 'section_two_a', 0, title: 'Two Dot A'
            end
            review_section 'review', 8
            signature_section 'signature', 9
          end
        end

        @spawner, @child2, @review_section, @signature_section = @root.children.order(:position)
        @two_a = @child2.children.first
      end

      it "should have the proper sections created, arranged and ordered" do
        expect(@root.title).to eq('Roto Rooter')
        expect(@root.name).to eq('roto_rooter')
        expect(@root.parent).to be_nil
        expect(@root.children).not_to be_empty
        expect(@root.questionnaire).to eq(@questionnaire)
        expect(@root.position).to eq(0)
        expect(@root).to be_persisted

        expect(@questionnaire.first_section).to eq(@spawner)
        expect(@spawner.title).to eq('Section One')
        expect(@spawner.name).to eq('section_one')
        expect(@spawner.parent).to eq(@root)
        expect(@spawner.children).to be_empty
        expect(@spawner.questionnaire).to eq(@questionnaire)
        expect(@spawner.position).to eq(0)
        expect(@spawner).to be_persisted

        expect(@child2.title).to eq('Section Two')
        expect(@child2.name).to eq('section_two')
        expect(@child2.parent).to eq(@root)
        expect(@child2.children).not_to be_empty
        expect(@child2.questionnaire).to eq(@questionnaire)
        expect(@child2.position).to eq(1)
        expect(@child2).to be_persisted

        expect(@two_a.title).to eq('Two Dot A')
        expect(@two_a.name).to eq('section_two_a')
        expect(@two_a.parent).to eq(@child2)
        expect(@two_a.children).to be_empty
        expect(@two_a.questionnaire).to eq(@questionnaire)
        expect(@two_a.position).to eq(0)
        expect(@two_a).to be_persisted

        expect(@review_section.title).to eq('Review')
        expect(@review_section.name).to eq('review')
        expect(@review_section.parent).to eq(@root)
        expect(@review_section.children).to be_empty
        expect(@review_section.questionnaire).to eq(@questionnaire)
        expect(@review_section.position).to eq(8)
        expect(@review_section).to be_persisted

        expect(@signature_section.title).to eq('Signature')
        expect(@signature_section.name).to eq('signature')
        expect(@signature_section.parent).to eq(@root)
        expect(@signature_section.children).to be_empty
        expect(@signature_section.questionnaire).to eq(@questionnaire)
        expect(@signature_section.position).to eq(9)
        expect(@signature_section).to be_persisted
      end
    end

    context 'when adding questions' do
      before do
        @evaluation_purpose = @questionnaire.evaluation_purposes.create! name: "eval_purp", title: "For evaluatin stuff", certificate_type: @questionnaire.certificate_type

        @root = @questionnaire.create_sections! do
          root 'roto_rooter', 0 do
            question_section 'section_one', 0, first: true do
              yesno 'first_question', 1, title: 'Do you like the first question?', positive_response: {eval_purp: 'yes'}, helpful_info: {default: 'words'}
              yesno 'disqualifier_q',2, title: 'You better answer yes.', positive_response: {eval_purp: 'yes'}, helpful_info: {default: 'words'}, disqualifier: {value: 'no', message: "You are wrong!"}

            end
            review_section 'review', 1
          end
        end

        @section_one = @root.children.order(:position).first
        @question_prez = @section_one.question_presentations.first
        @disqualifying_q = @section_one.question_presentations.last
      end

      it "should have the proper sections created, arranged and ordered" do
        expect(@root.arrangement).to eq([
                                            {
                                                name: 'roto_rooter',
                                                title: 'Roto Rooter',
                                                position: 0,
                                                type: 'root',
                                                questionnaire_id: @questionnaire.id,
                                                sba_application_id: nil,
                                                children: [
                                                    {
                                                        name: 'section_one',
                                                        title: 'Section One',
                                                        position: 0,
                                                        type: 'question_section',
                                                        questionnaire_id: @questionnaire.id,
                                                        sba_application_id: nil,
                                                        children: []
                                                    },
                                                    {
                                                        name: 'review',
                                                        title: 'Review',
                                                        position: 1,
                                                        type: 'review_section',
                                                        questionnaire_id: @questionnaire.id,
                                                        sba_application_id: nil,
                                                        children: []
                                                    }
                                                ]
                                            }
                                        ])

        expect(@section_one.question_presentations.count).to eq(2)
        expect(@question_prez.name).to eq('first_question')
        expect(@question_prez.title).to eq('Do you like the first question?')
        expect(@question_prez.position).to eq(1)
        expect(@question_prez.type_name).to eq('yesno')
        expect(@question_prez.positive_response_for('eval_purp')).to eq('yes')
      end

      it 'should setup disqualifiers' do
        expect(@disqualifying_q.disqualifier).not_to be_nil
        expect(@disqualifying_q.disqualifier.value).to eq('no')
        expect(@disqualifying_q.disqualifier.message).to eq('You are wrong!')
        expect(@disqualifying_q.is_disqualifying?).to be_truthy
        expect(@question_prez.is_disqualifying?).to be_falsey
      end
    end

    context 'when creating templates' do
      before do
        @template = @questionnaire.create_sections! do
          template 'knights', 0 do
            template 'templar', 0
            template 'other_stuff', 1
          end
        end
      end

      it "should have the proper sections created, arranged and ordered" do
        expect(@template.arrangement).to eq([
                                                {
                                                    name: 'knights',
                                                    title: 'Knights',
                                                    position: 0,
                                                    type: 'template',
                                                    questionnaire_id: @questionnaire.id,
                                                    sba_application_id: nil,
                                                    children: [
                                                        {
                                                            name: 'templar',
                                                            title: 'Templar',
                                                            position: 0,
                                                            type: 'template',
                                                            questionnaire_id: @questionnaire.id,
                                                            sba_application_id: nil,
                                                            children: []
                                                        },
                                                        {
                                                            name: 'other_stuff',
                                                            title: 'Other Stuff',
                                                            position: 1,
                                                            type: 'template',
                                                            questionnaire_id: @questionnaire.id,
                                                            sba_application_id: nil,
                                                            children: []
                                                        }
                                                    ]
                                                }
                                            ])

        expect(@questionnaire.root_section).to be_nil
        expect(@questionnaire.templates.count).to eq(1)
        expect(@questionnaire.templates).to include(@template)
      end
    end
  end
end