require 'questionnaire/master_questionnaire'

# Do they need to be tagged with the calendar year?
# The annual update app is created 60 days after the initial approval date - rake task, class method and cron job
# Can submit at any time.
# Adhoc reviews on annual reviews -> Deficiency letter is similar to a 15 day letter
# initiate termination... even if they don't submit the cert

class Questionnaire::EightAAnnualReview < Questionnaire::MasterQuestionnaire
  def self.create_application!(org)
    unless org.default_user
      raise "Do not create annual reviews for orgs that don't have any users"
    end

    app = first.start_application(org)
    app.kind = 'annual_review'
    app.creator = org.default_user
    app.save!
    app
  end

  def start_application(org, options = {})
    if org.certificates.eight_a.empty? || ! org.certificates.eight_a.first.active?
      raise "You must have an active 8(a) certificate to start an annual review"
    end

    SbaApplication::EightAAnnualReview.new(options.merge(organization: org, questionnaire: self, prerequisite_order: prerequisite_order, certificate: org.certificates.eight_a.first))
  end
end
