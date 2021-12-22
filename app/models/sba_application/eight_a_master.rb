require 'sba_application/master_application'

class SbaApplication::EightAMaster < SbaApplication::MasterApplication
  include MasterApplicationWorkflow

  def self.do_supervisor_assigned_cases(user)
    eight_a.with_valid_cert.assigned_workload(user.id)
  end

  def self.do_supervisor_unassigned_cases(user)
    eight_a.
        has_bdmis_case.not_in_review.with_valid_cert.
        joins(:duty_stations).where('duty_stations.id' => user.duty_stations.map(&:id)).
        order(created_at: :asc)
  end

  def start_review_process(user)
    case kind
    when INITIAL
      reviews << Review::EightAInitial.create_and_assign_review(user, self)
    when ANNUAL_REVIEW
      previous_review = self.current_review
      review = Review::EightAAnnualReview.create_and_assign_review(user, self)
      review.process! if previous_review&.returned_with_deficiency_letter_while_in_processing?
      reviews << review
    end
    self.ignore_creator = true
    save!
    # NEED TO UPDATE APPLICATION STATUS HERE EVENTUALLY.
  end
end