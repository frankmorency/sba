require_relative '../section'

class Section::MasterApplicationSection < Section

  SUBMISSION_CHECK_SECTIONS = ['Section::ReconsiderationSection', 'Section::SubApplication', 'Section::ContributorSection']

  def sections_for_submission_check
    children.where(type: SUBMISSION_CHECK_SECTIONS)
  end

  def sub_application_sections(user = nil)
    if user
      children.where.not(type: not_included(user)).order(position: :asc)
    else
      children
    end
  end

  private

  # TODO simplify this and the corresponding tests
  def not_included(user)

    if user.is_vendor? && sba_application.draft? && !sba_application.is_under_reconsideration?
      ['Section::AdhocQuestionnairesSection', 'Section::ReconsiderationSection']
    elsif user.is_vendor? && sba_application.submitted? && sba_application.is_under_reconsideration?
      ['Section::AdhocQuestionnairesSection', 'Section::ContributorSection']
    elsif user.is_vendor? && sba_application.submitted? && sba_application.current_review && sba_application.current_review.pending_reconsideration_or_appeal?
      ['Section::AdhocQuestionnairesSection', 'Section::ContributorSection']
    elsif user.is_vendor? && sba_application.submitted?
      ['Section::ReconsiderationSection', 'Section::AdhocQuestionnairesSection', 'Section::ContributorSection']
    elsif user.is_vendor? && sba_application.submitted? && sba_application.current_review && !sba_application.current_review.pending_reconsideration_or_appeal?
      ['Section::ReconsiderationSection', 'Section::AdhocQuestionnairesSection', 'Section::ContributorSection']
    elsif user.is_sba? && sba_application.current_review.nil?
      ['Section::ReconsiderationSection', 'Section::AdhocQuestionnairesSection', 'Section::ContributorSection']
    elsif user.is_sba? && sba_application.is_under_reconsideration?
      ['Section::AdhocQuestionnairesSection', 'Section::ContributorSection']
    elsif user.is_sba? && sba_application.current_review && !(sba_application.current_review.appeal_intent? || sba_application.current_review.reconsideration?)
      ['Section::ReconsiderationSection', 'Section::AdhocQuestionnairesSection', 'Section::ContributorSection']
    else
      ['Section::AdhocQuestionnairesSection', 'Section::ContributorSection']
    end
  end
end

