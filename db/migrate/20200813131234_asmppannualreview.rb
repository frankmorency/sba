class Asmppannualreview < ActiveRecord::Migration
  def change
    q = Question.find_by(name: "mpp_annual_review")
    q.update_attribute("title", '<p>The ASMPP annual reporting is now satisfied by the Protégé completing the Annual Evaluation Report . <a href="/mpp_annual_evaluation_pdf/ASMPP_AnnualEvaluationReport_SurveyGuide.pdf" target="_blank">Click Here </a> to access a guide that outlines the contents of the Annual Evaluation Report.</p><ol><li> <a href="https://www.surveymonkey.com/r/ASMPPAE" target="_blank">ASMPP Annual Evaluation</a></li> </ol>')
    q.save!
  end
end
