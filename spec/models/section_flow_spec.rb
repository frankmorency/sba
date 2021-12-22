require 'rails_helper'

RSpec.describe Section, type: :model do
  before do
    create_basic_app
  end

  context 'for a simple linear flow: 11 -> 12 -> 21 -> 22' do
    before do
      @rule_list = [
          create(:section_rule, sba_application: @app, questionnaire: @app.master,
                 from_section: @section11, to_section: @section12),
          create(:section_rule, sba_application: @app, questionnaire: @app.master,
                 from_section: @section12, to_section: @section21),
          create(:section_rule, sba_application: @app, questionnaire: @app.master,
                 from_section: @section21, to_section: @section22)

      ]

      @app.update_skip_info! # normally done after the app is created, but... that step is deferred here for tests
    end

    describe "#next_section" do
      it 'should progress as expected' do
        expect(@section11.next_section(@user, @app.id).first).to eq(@section12)
        expect(@section12.next_section(@user, @app.id).first).to eq(@section21)
        expect(@section21.next_section(@user, @app.id).first).to eq(@section22)
      end

      it 'should progress generate the proper skip info' do
        expect(@section11.next_section(@user, @app.id).last).to eq({"notapplicable"=>[], "applicable"=>["section_1_2", "section_2_1", "section_2_2"]})
        expect(@section12.next_section(@user, @app.id).last).to eq({"notapplicable"=>[], "applicable"=>["section_2_1", "section_2_2"]})
        expect(@section21.next_section(@user, @app.id).last).to eq({"notapplicable"=>[], "applicable"=>["section_2_2"]})
      end
    end
  end

  context 'for a single jump question: 11 -> 12 (11n) -> 21 (11y) -> 22' do
    context 'answering no' do
      before do
        @answer = create(:answer_boolean, sba_application: @app, value: {'value' => 'no'})

        @rule_list = [
            create(:section_rule, sba_application: @app, questionnaire: @app.master,
                   from_section: @section11, to_section: @section12,
                   expression: {
                       klass: 'Answer', identifier: @answer.question.name, value: 'no'
                   }),
            create(:section_rule, sba_application: @app, questionnaire: @app.master,
                   from_section: @section11, to_section: @section21,
                   expression: {
                       klass: 'Answer', identifier: @answer.question.name, value: 'yes'
                   }),
            create(:section_rule, sba_application: @app, questionnaire: @app.master,
                   from_section: @section12, to_section: @section21),
            create(:section_rule, sba_application: @app, questionnaire: @app.master,
                   from_section: @section21, to_section: @section22)

        ]

        @app.update_skip_info! # normally done after the app is created, but... that step is deferred here for tests
      end

      describe "#next_section" do
        it 'should progress as expected' do
          expect(@section11.next_section(@user, @app.id).first).to eq(@section12)
          expect(@section12.next_section(@user, @app.id).first).to eq(@section21)
          expect(@section21.next_section(@user, @app.id).first).to eq(@section22)
        end

        it 'should progress generate the proper skip info' do
          expect(@section11.next_section(@user, @app.id).last).to eq({"notapplicable"=>[], "applicable"=>["section_1_2", "section_2_1", "section_2_2"]})
          expect(@section12.next_section(@user, @app.id).last).to eq({"notapplicable"=>[], "applicable"=>["section_2_1", "section_2_2"]})
          expect(@section21.next_section(@user, @app.id).last).to eq({"notapplicable"=>[], "applicable"=>["section_2_2"]})
        end
      end
    end


    context 'answering yes' do
      before do
        @answer = create(:answer_boolean, sba_application: @app, value: {'value' => 'yes'})

        @rule_list = [
            create(:section_rule, sba_application: @app, questionnaire: @app.master,
                   from_section: @section11, to_section: @section12,
                   expression: {
                       klass: 'Answer', identifier: @answer.question.name, value: 'no'
                   }),
            create(:section_rule, sba_application: @app, questionnaire: @app.master,
                   from_section: @section11, to_section: @section21,
                   expression: {
                       klass: 'Answer', identifier: @answer.question.name, value: 'yes'
                   }),
            create(:section_rule, sba_application: @app, questionnaire: @app.master,
                   from_section: @section12, to_section: @section21),
            create(:section_rule, sba_application: @app, questionnaire: @app.master,
                   from_section: @section21, to_section: @section22)

        ]

        @app.update_skip_info! # normally done after the app is created, but... that step is deferred here for tests
      end

      describe "#next_section" do
        it 'should progress as expected' do
          expect(@section11.next_section(@user, @app.id).first).to eq(@section21)
          expect(@section21.next_section(@user, @app.id).first).to eq(@section22)
        end

        it 'should progress generate the proper skip info' do
          expect(@section11.next_section(@user, @app.id).last).to eq({"notapplicable"=>["section_1_2"], "applicable"=>["section_2_1", "section_2_2"]})
          expect(@section21.next_section(@user, @app.id).last).to eq({"notapplicable"=>[], "applicable"=>["section_2_2"]})
        end
      end
    end
  end

  context 'with a multi-path question ' do
    context 'hitting all paths: 11 -> 12 (q12y) -> 21 (q21y) -> 22' do
      before do
        @answer12 = create(:answer_boolean, sba_application: @app, value: {'value' => 'yes'})
        @answer21 = create(:answer_boolean, sba_application: @app, value: {'value' => 'yes'})

        @rule_11_multi = create(:section_rule, sba_application: @app,
                                questionnaire: @app.master,
                                from_section: @section11,
                                to_section: @section22,
                                terminal_section: @section22,
                                is_multi_path_template: true,
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

        @app.update_skip_info! # normally done after the app is created, but... that step is deferred here for tests
      end

      describe "#next_section" do
        it 'should generate the proper intermediate section rules' do
          @section11.next_section(@user, @app.id)
          expect(@rule_11_multi.generated_rules.map(&:to_s)).to include('section_1_2 => section_2_1')
          expect(@rule_11_multi.generated_rules.map(&:to_s)).to include('section_2_1 => section_2_2')
          expect(@rule_11_multi.reload.to_section.name).to eq('section_1_2')
        end

        it 'should progress as expected' do
          expect(@section11.next_section(@user, @app.id).first).to eq(@section12)
          expect(@section12.next_section(@user, @app.id).first).to eq(@section21)
          expect(@section21.next_section(@user, @app.id).first).to eq(@section22)
        end

        it 'should progress generate the proper skip info' do
          skip_info = @section11.next_section(@user, @app.id).last
          expect(skip_info['notapplicable']).to be_empty
          expect(skip_info['applicable']).to include('section_1_2')
          expect(skip_info['applicable']).to include('section_2_1')
          expect(skip_info['applicable']).to include('section_2_2')

          skip_info = @section12.next_section(@user, @app.id).last
          expect(skip_info['notapplicable']).to be_empty
          expect(skip_info['applicable']).to include('section_2_1')
          expect(skip_info['applicable']).to include('section_2_2')

          skip_info = @section21.next_section(@user, @app.id).last
          expect(skip_info['applicable']).to eq(['section_2_2'])
          expect(skip_info['notapplicable']).to be_empty
        end
      end
    end
    context 'hitting some paths: 11 --- 12 (q12n) ---> 21 (q21y) -> 22' do
      before do
        @answer12 = create(:answer_boolean, sba_application: @app, value: {'value' => 'no'})
        @answer21 = create(:answer_boolean, sba_application: @app, value: {'value' => 'yes'})

        @rule_11_multi = create(:section_rule, sba_application: @app,
                                questionnaire: @app.master,
                                from_section: @section11,
                                to_section: @section22,
                                terminal_section: @section22,
                                is_multi_path_template: true,
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

        @app.update_skip_info! # normally done after the app is created, but... that step is deferred here for tests
      end

      pending "#next_section" do
        it 'should generate the proper intermediate section rules' do
          @section11.next_section(@user, @app.id)
          expect(@rule_11_multi.generated_rules.map(&:to_s)).to include('section_2_1 => section_2_2')
          expect(@rule_11_multi.reload.to_section.name).to eq('section_2_1')
        end

        it 'should progress as expected' do
          expect(@section11.next_section(@user, @app.id).first).to eq(@section21)
          expect(@section21.next_section(@user, @app.id).first).to eq(@section22)
        end

        it 'should generate the proper skip info' do
          skip_info = @section11.next_section(@user, @app.id).last
          expect(skip_info['notapplicable']).to include('section_1_2')
          expect(skip_info['applicable']).to include('section_2_1')
          expect(skip_info['applicable']).to include('section_2_2')

          skip_info = @section21.next_section(@user, @app.id).last
          expect(skip_info['applicable']).to eq(['section_2_2'])
          expect(skip_info['notapplicable']).to be_empty
        end
      end
    end

    context 'hitting no paths: 11 --- 12 (q12n) ---  21 (q21n) ---> 22' do
      before do
        @answer12 = create(:answer_boolean, sba_application: @app, value: {'value' => 'no'})
        @answer21 = create(:answer_boolean, sba_application: @app, value: {'value' => 'no'})

        @rule_11_multi = create(:section_rule, sba_application: @app,
                                questionnaire: @app.master,
                                from_section: @section11,
                                to_section: @section22,
                                terminal_section: @section22,
                                is_multi_path_template: true,
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

        @app.update_skip_info! # normally done after the app is created, but... that step is deferred here for tests
      end

      describe "#next_section" do
        it 'should generate the proper intermediate section rules' do
          @section11.next_section(@user, @app.id)
          expect(@rule_11_multi.generated_rules.map(&:to_s)).to be_empty
          expect(@rule_11_multi.reload.to_section.name).to eq('section_2_2')
        end

        it 'should progress as expected' do
          expect(@section11.next_section(@user, @app.id).first).to eq(@section22)
        end

        it 'should generate the proper skip info' do
          skip_info = @section11.next_section(@user, @app.id).last
          expect(skip_info['notapplicable']).to include('section_1_2')
          expect(skip_info['notapplicable']).to include('section_2_1')
          expect(skip_info['applicable']).to include('section_2_2')
        end
      end
    end
  end
end