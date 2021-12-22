class CertificateType < ActiveRecord::Base
  include NameRequirements

  FINANCIAL_REVIEW_CERTS = %w(edwosb)
  SUMMARY_THANKS_CERTS = %w(mpp)
  DISPLAY_PDF_LETTER_CERTS = %w(wosb edwosb)

  acts_as_paranoid
  has_paper_trail

  has_many :questionnaires
  has_many :eligible_naic_codes
  has_many :evaluation_purposes
  has_many :sba_applications # belongs directly to a questionnaire
  has_many :certificates
  has_many :current_questionnaires, -> { order(updated_at: "DESC") }
  has_many :questionnaire_histories

  def initial_questionnaires
    questionnaire_histories.where(kind: SbaApplication::INITIAL).map(&:questionnaire)
  end

  def questionnaire(type)
    if Rails.env.production? || Rails.env.stage?
      return false unless cq = current_questionnaires.find_by(kind: type, for_testing: false)
    else
      return false unless cq = current_questionnaires.find_by(kind: type)
    end

    cq.questionnaire
  end

  def initial_questionnaire
    questionnaire SbaApplication::INITIAL
  end

  def annual_review_questionnaire
    questionnaire SbaApplication::ANNUAL_REVIEW
  end

  def super_short_name
    name.upcase
  end

  def short_name
    "#{super_short_name} Certification"
  end

  def display_summary_thanks?
    SUMMARY_THANKS_CERTS.include? name
  end

  def display_pdf_letter_tab?
    DISPLAY_PDF_LETTER_CERTS.include? name
  end

  def has_financial_review_section?
    FINANCIAL_REVIEW_CERTS.include? name
  end
end
