module CasesMashup
  extend ActiveSupport::Concern

  def get_last_reviewer
    reviewer = nil

    if current_review
      reviewer = current_review.current_assignment.reviewer if current_review && current_review.current_assignment
    end

    if !annual_reports.empty?
      reviewer = annual_reports.last.reviewer  if annual_reports && annual_reports.last
    end
    return reviewer
  end

  def get_last_owner
    reviewer = nil

    if current_review
      reviewer = current_review.current_assignment.owner  if current_review && current_review.current_assignment
    end

    if !annual_reports.empty?
      reviewer = current_review.current_assignment.reviewer if current_review && current_review.current_assignment
    end
    return reviewer
  end

  def get_review_type
    reviewer = nil

    if current_review
      reviewer = "Initial"
    end

    if !annual_reports.empty?
      reviewer = "Annual Report"
    end
    return reviewer

  end

  def program
    current_application.program
  end
end