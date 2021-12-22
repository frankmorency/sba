require 'csv'

class Permissions::ValidityMatrix
  QUESTIONNAIRES = [:eight_a]

  REVIEW_STATES = Review::EightA::STATUSES.map(&:to_sym) + [:unassigned]

  PERMISSIONS = [
      :can_view_adhoc_footer,
      :can_view_section_card_menu,
      :can_request_section_revisions,
      :can_add_note,
      :can_send_message,
      :can_return_master_application,
      :can_return_sub_application,
      :can_upload_document,
      :can_refer_case,
      :can_make_recommendation,
      :can_make_determination,
      :can_accept_for_processing,
      :can_close_case,
      :can_reassign_case,
      :can_retain_firm,
      :can_change_due_date,
      :can_initiate_adverse_action,
      :can_send_deficiency_letter_in_processsing
  ]

  ROLES = [
      :sba_director_8a_district_office,
      :sba_deputy_director_8a_district_office,
      :sba_supervisor_8a_district_office,
      :sba_supervisor_8a_hq_aa,
      :sba_supervisor_8a_hq_program,
      :sba_supervisor_8a_cods,
      :sba_analyst_8a_district_office,
      :sba_analyst_8a_hq_program,
      :sba_analyst_8a_cods,
      :sba_supervisor_user,
      :vendor_user,
      :contributor_user
  ]

  attr_reader :permissions

  def self.load(file = 'sba_permissions')
    new File.join(File.dirname(__FILE__), 'fixtures', 'permissions', "#{file}.csv")
  end

  def initialize(file)
    @permissions = {
        eight_a: { }
    }

    REVIEW_STATES.each do |state|
      @permissions[:eight_a][state] = permissions_hash
    end

    i = 1
    CSV.foreach(file, headers: true, header_converters: :symbol) do |line|
      next unless line[:ignore].blank?
      if i == 1
        expected_headers.each do |header|
          unless line.headers.include? header
            raise "Expected header (#{header}) not found in CSV file"
          end
        end

        extra_headers = line.headers - expected_headers

        unless extra_headers.empty?
          raise "Unexpected headers (#{extra_headers.join}) found in CSV file"
        end
      end

      raise "Line #{i} of #{file}: #{line[:questionnaire]} is not a valid questionnaire name" unless QUESTIONNAIRES.include?(line[:questionnaire].to_sym)
      raise "Line #{i} of #{file}: #{line[:review_state]} is not a valid review state" unless REVIEW_STATES.include?(line[:review_state].to_sym)
      raise "Line #{i} of #{file}: #{line[:permission]} is not a valid permission" unless PERMISSIONS.include?(line[:permission].to_sym)

      @permissions[line[:questionnaire].to_sym][line[:review_state].to_sym][line[:permission].to_sym] = line.to_hash.reject {|k| !(ROLES + [:is_case_owner, :is_reviewer]).include?(k) }.merge(line_number: i)
      i += 1
    end
  end

  def status(q, review, perm, role)
    !! @permissions[q][review][perm][role]
  end

  private

  def permissions_hash
    PERMISSIONS.inject({}) {|hash, method| hash[method] = {} }
  end

  def expected_headers
    ROLES + [:is_case_owner, :is_reviewer, :questionnaire, :permission, :review_state, :ignore, :special_conditions]
  end
end