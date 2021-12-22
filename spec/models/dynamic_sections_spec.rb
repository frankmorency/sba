require 'rails_helper'

RSpec.describe 'Dynamic Sections', type: :model do
  before do
    # @questionnaire = Questionnaire.create! name: 'section_cert', title: 'Section Cert', anonymous: false
    # @cert = CertificateType.create! name: 'section_cert', title: 'Section Cert', questionnaire: @questionnaire
    #
    # @owner_list_413 = QuestionType::OwnerList.create! name: 'owner_list', title: 'Form 413 Owner List'
    # @owner_list_413 = @owner_list_413.questions.create! name: 'owner_list_413', title: 'Who are the owners / partners in your company?'
    #
    # @eval_purpose = EvaluationPurpose.create! name: "section_certification", title: "Section Certification", certificate_type: @cert, questionnaire: @questionnaire
    #
    # @template = Section::Template.create! name: "template_413_root", title: "{value} 413", questionnaire: @questionnaire, submit_text: "Save & Continue"
    # @template_sub1 = Section::Template.create! name: "template_413_assets", title: "Assets", questionnaire: @questionnaire, submit_text: "Save & Continue"
    # @template_sub2 = Section::Template.create! name: "template_413_liabilities", title: "Liabilities", questionnaire: @questionnaire, submit_text: "Save & Continue"
    #
    #
    # @root = Section::Root.create! name: "dynamic_test_root", title: "Dynamic Test Root", questionnaire: @questionnaire, submit_text: "Save & Continue"
    # @questionnaire.root_section = @root
    # @questionnaire.save!
    #
    # @spawner = Section::Spawner.create! name: "owners_section", title: "List of Owners Section", questionnaire: @questionnaire, submit_text: "Save & Continue", template: @template, repeat: {name: '{value} 413', minimum: 1, maximum: 9}, parent: @root, position: 0
    # @end_section = Section::ReviewSection.create! name: "end_section", title: "End Section", questionnaire: @questionnaire, submit_text: "All Good?", parent: @root, position: 10
    #
    # @presentation = spawner.add_question @eval_purpose, @owner_list_413, 1, defaut: 'You must list at least one person'
    # @spawner.add_question @eval_purpose, Question.make!('yesno', 'random_bool','Do you like smurfs?'), 2, 'no', default: 'words'
    # @spawner.update_attribute :repeat, {model: 'BusinessPartner', decision_id: @presentation.id, parent_id: @spawner.id, starting_position: 1, next_section_id: @end_section.id}
    #
    # @template_sub1.add_question @eval_purpose, Question.make!('yesno', 'random_bool_too', 'How much moey do you make?'), 1, 'yes', default: 'words'
    # @template_sub2.add_question @eval_purpose, Question.make!('yesno', 'random_bool_tree', 'How much moey do you owe?'), 1, 'yes', default: 'words'
  end
end