require 'factory_bot'
require_relative '../fixtures/sample_application'

module SbaApplicationHelpers
  def vendor_user
    create(:vendor_user_with_org)
  end

  def qid(name)
    Question.get(name).id
  end

  def stub_persisted_app
    app = build(:persisted_application)
    allow(SbaApplication).to receive(:find).and_return app
  end

  def load_sample_questionnaire(type = 'edwosb')
    if type == 'eight_a_annual_review'
      CertificateType.find_by(name: 'eight_a')
    else
      CertificateType.find_by(name: 'wosb')
    end
  end

  def create_basic_app
    @user = create(:user_with_org)
    @app = create(:basic_application, organization: @user.one_and_only_org)

    # section_1
    # -- section_1_1
    # -- section_1_2
    # section_2
    # -- section_2_1
    # -- section_2_2
    # section_3

    @root = create(:section_root, sba_application: @app, questionnaire: @app.master)
    @section1 = create(:section_1, parent: @root, sba_application: @app, questionnaire: @app.master)
    @section11 = create(:section_1_1, parent: @section1, sba_application: @app, questionnaire: @app.master)
    @section12 = create(:section_1_2, parent: @section1, sba_application: @app, questionnaire: @app.master)

    @section2 = create(:section_2, parent: @root, sba_application: @app, questionnaire: @app.master)
    @section21 = create(:section_2_1, parent: @section2, sba_application: @app, questionnaire: @app.master)
    @section22 = create(:section_2_2, parent: @section2, sba_application: @app, questionnaire: @app.master)

    @section3 = create(:section_3, parent: @root, sba_application: @app, questionnaire: @app.master)

    @app.update_attribute(:root_section_id, @root.id)
    @app.update_attribute(:first_section_id, @section11.id)
  end

  def answer_params(section, *values)
    Hash[ section.question_presentations.map(&:id).zip(values.map {|value| build(:answer_params, value: value) }) ]
  end

  def setup_am_i_eligible(strategy = :correct)
    q1 = create(:amieligible_pres_1)
    q2 = create(:amieligible_pres_2)
    q3 = create(:amieligible_pres_3)

    aq1 = create(:wosb_aq_1)
    aq2 = create(:wosb_aq_2)
    aq3 = create(:edwosb_aq_1)
    aq4 = create(:edwosb_aq_2)


    case strategy
      when :correct
        create(:answer_yes, question: q1.question)
        create(:answer_yes, question: q2.question)
        create(:answer_naics, question: q3.question)
      when :incorrect
        create(:answer_yes, question: q1.question)
        create(:answer_no, question: q2.question)
        create(:answer_naics, question: q3.question)
      when :incorrect_edwosb
        create(:answer_yes, question: q1.question)
        create(:answer_yes, question: q2.question)
        create(:answer_naics_wrong, question: q3.question)
      when :incomplete
        create(:answer_yes, question: q2.question)
        create(:answer_naics, question: q3.question)
    end

    [aq1.evaluation_purpose, aq3.evaluation_purpose]
  end
end

RSpec::Matchers.define :be_arranged_like do |expected|
  match do |actual|
    actual == Array.wrap(expected)
  end
end
