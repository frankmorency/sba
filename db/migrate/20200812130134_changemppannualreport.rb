class Changemppannualreport < ActiveRecord::Migration
  def change
    q = Question.find_by(name: "mpp_annual_review")
    q.update_attribute("title", '<p>"The ASMPP annual reporting is now satisfied by the Protege by completing the form listed below:"</p><ol><li> <a href="/mpp_annual_evaluation_pdf/ASMPP_AnnualEvaluationReport_SurveyGuide.pdf" target="_blank">Annual Evaluation Report Survey Guide (PDF)</a></li><li> <a href="https://www.surveymonkey.com/r/ASMPPAE" target="_blank">ASMPP Annual Evaluation</a></li> </ol>')
    q.save!
  end
end
