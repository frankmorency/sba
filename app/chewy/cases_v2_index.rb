class CasesV2Index < Chewy::Index
  define_type Organization.includes(:certificates, :sba_applications) do

    field :firm_name, fielddata: 'true', value: -> (organization) { organization.legal_business_name }
    field :firm_name_autocomplete, type:'completion', value: -> (organization) { organization.legal_business_name }
    field :firm_name_sort, index:'not_analyzed', value: -> (organization) { organization.legal_business_name }
    field :duns, value: -> (organization) { organization.duns_number }
    # field :duns_autocomplete, type:'completion', value: -> (organization) { organization.duns_number }
    field :firm_owner, value: -> (organization) { organization.vendor_admin_user&.name }
    # field :firm_owner_autocomplete, type:'completion', value: -> (organization) { organization.vendor_admin_user&.name }
    field :firm_type, value: -> (organization) { organization.business_type }
    field :naics, value: -> (organization) { organization.to_sam&.primary_naics }
    field :cage, index: 'no', value: -> (organization) { organization.to_sam&.cage_code }
    field :dba, index: 'no', value: -> (organization) { organization.to_sam&.dba_name }
    field :entity_number, index: 'no', value: -> (organization) { organization.tax_identifier }
    field :firm_contact, index: 'no', value: -> (organization) { organization.to_sam&.govt_bus_poc_last_name }
    field :email, index: 'no', value: -> (organization) { organization.to_sam&.govt_bus_poc_email }
    field :phone_number, index: 'no', value: -> (organization) { organization.to_sam&.govt_bus_poc_us_phone }
    field :mailing_address, index: 'no', value: -> (organization) { organization.to_sam&.mailing_address_line_1 }

    field :submit_date_eight_a, index: 'not_analyzed', value: -> \
      (organization) { organization.sba_applications.joins(certificate: :certificate_type).where('certificate_types.name = ?', 'eight_a').maximum(:application_submitted_at)&.to_date }

    field :start_date_eight_a, index: 'not_analyzed', value: -> \
      (organization) { organization.sba_applications.joins(certificate: :certificate_type).where('certificate_types.name = ?', 'eight_a').maximum(:issue_date)&.to_date }

    field :submit_date_mpp, index: 'not_analyzed', value: -> \
      (organization) { organization.sba_applications.joins(certificate: :certificate_type).where('certificate_types.name = ?', 'mpp').maximum(:application_submitted_at)&.to_date }

    field :submit_date_wosb, index: 'not_analyzed', value: -> \
      (organization) { organization.sba_applications.joins(certificate: :certificate_type).where("certificate_types.name IN ('wosb','edwosb')").maximum(:application_submitted_at)&.to_date }

    field :next_action_due_date, index: 'not_analyzed', value: -> (organization) { organization.next_action_due_date_newest }

    # field :certificate_anniversary_eight_a, index: 'not_analyzed', value: -> \
    #   (organization) { organization.certificates.joins(:certificate_type).where('certificate_types.name = ?', 'eight_a').maximum(:issue_date)&.to_date&.strftime("%m%d%y") }

    field :certificate_start_date_eight_a, index: 'not_analyzed', value: -> \
      (organization) { organization.certificates.joins(:certificate_type).where('certificate_types.name = ?', 'eight_a').maximum(:issue_date)&.to_date }

    field :certificates, type: 'nested' do
      field :id, index: 'no', value: -> (certificate) {certificate&.certificate_type&.id}
      field :program_title, value: -> (certificate) { certificate&.certificate_type&.title }
      field :program, value: -> (certificate) { certificate&.certificate_type&.super_short_name }

      field :review_type, index: 'not_analyzed', value: -> (certificate) { certificate.current_review&.type }
      field :status, index: 'not_analyzed', value: -> (certificate) { certificate.workflow_state }
      field :status_humanized, index: 'no', value: -> (certificate) { certificate.display_status }
      field :date_submitted, type: 'date', value: -> (certificate) { certificate.current_application.application_submitted_at&.to_date }
      field :anniversary_date, value: -> (certificate) { certificate.issue_date&.strftime("%m/%d") }
      field :due_date, value: -> (certificate) {certificate.current_application.screening_due_date}
      field :expiration_date, type: 'date', value: -> (certificate) { certificate.expiry_date&.to_date }
      field :approval_date, type: 'date', value: -> (certificate) { certificate.issue_date&.to_date }

      field :case_owner_id, index: 'no', value: -> (certificate) { certificate.current_review&.current_assignment&.owner&.id }
      field :current_reviewer_id, index: 'no', value: -> (certificate) {certificate.current_review&.current_assignment&.reviewer&.id }

      field :case_owner, type: 'string', index: 'not_analyzed', value: -> (certificate) { certificate.current_review&.current_assignment&.owner&.name }
      field :current_reviewer, type: 'string', index: 'not_analyzed', value: -> (certificate) {certificate.current_review&.current_assignment&.reviewer&.name }
      field :district_office, value: -> (certificate) { certificate.duty_station&.name }
      field :servicing_bos, value: -> (certificate) { certificate&.servicing_bos&.name }

      field :reviews, type: 'nested' do
        field :id, index: 'no'
        field :type
        field :status, index: 'not_analyzed', value: -> (review) { review&.workflow_state }
        field :status_humanized, index: 'no', value: -> (review) { review&.display_status }
        field :determination, index: 'not_analyzed', value: -> (review) { review&.determination&.decision }
        field :determination_humanized, index: 'no', value: -> (review) { review&.determination&.display_decision }
        field :case_owner, value: -> (review) { review&.current_assignment&.owner&.name }
        # field :case_owner_autocomplete, type:'completion', value: -> (review) { review&.current_assignment&.owner&.name }
        field :current_reviewer, value: -> (review) { review&.current_assignment&.reviewer&.name }
        field :date_created, index: 'no', value: -> (review) { review&.created_at&.to_date }
        field :screening_due_date, type: 'date', value: -> (review) { review&.screening_due_date&.to_date }
        field :processing_due_date, type: 'date', value: -> (review) { review&.processing_due_date&.to_date }
        field :letter_due_date, type: 'date', value: -> (review) { review&.letter_due_date&.to_date }
      end
    end

    field :sba_applications, type: 'nested' do
      field :id, index: 'no'
      field :type, index: 'no'
      field :date_submitted, type: 'date', index: 'no', value: -> (application) { application.application_submitted_at&.to_date }
      field :due_date, index: 'no', value: -> (application) { application.screening_due_date}
    end
  end
end

# program_title
# 8(a)
# Women-Owned Small Business
# Economically Disadvantaged Women-Owned Small Business
# 8(a) Disadvantaged Individual
# 8(a) Business Partner
# 8(a) Spouse
# Mentor Protégé Program

# program
# eight_a
# wosb
# edwosb
# eight_a_disadvantaged_individual
# eight_a_business_partner
# eight_a_spouse
# mpp

# review type
# Review::EightAInitial
# Review::EightA
# Review::EightAAnnualReview
# Review::Initial

# review / status
# cancelled
# retained
# recommend_eligible
# sba_declined
# returned_with_deficiency_letter
# returned_for_modification
# returned_with_15_day_letter
# unassigned
# screening
# processing
# recommend_ineligible
# appeal
# under_review
# sba_approved
# determination_made
# assigned_in_progress

# review / display_status
# assigned_in_progress => Review Started
# returned_for_modification => Return for Modification
# recommend_ineligible => Recommend Ineligible
# recommend_eligible => Recommend Eligible
# determination_made => Determination Made
# pending_reconsideration_or_appeal => Pending Appeal
# appeal Appeal
# reconsideration Reconsideration

# certificate / status
# ineligible
# active
# expired
# pending
# inactive
