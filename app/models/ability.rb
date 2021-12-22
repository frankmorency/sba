class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, :to => :crud

    # required for guest user
    user ||= User.new

    cannot :ensure_vendor, User                                                       # (Defined below)
    cannot :view_vendor_navbar, User
    cannot :view_business_profile, User                                               # (Defined below)
    cannot :view_document_library, User                                               # (Defined below)
    cannot :view_personal_profile, User                                               # (Defined below)
    cannot :work_on_edwosb_wosb_application, User                                     # (Defined below)
    cannot :mange_help_pages, User                                                    # (Defined below)
    cannot :edit, HelpPage                                                            # (Defined below)
    cannot :view_sba_analyst_dashboard, User                                          # (Defined below)
    cannot :ensure_vendor_admin, User                                                 # (Defined below)
    cannot :sba_user, User                                                            # (Defined below)
    cannot :ensure_admin, User                                                        # (Defined below)
    cannot :view_vendor_individual_profile, User                                      # (Defined below)
    cannot :view_vendor_application, User                                             # (Defined below)
    cannot :view_vendor_dashboard, User                                               # (Defined below)
    cannot :view_vendor_profile, User                                                 # (Defined below)
    cannot :view_vendor_certification, User                                           # (Defined below)
    cannot :view_vendor_documents, User                                               # (Defined below)
    cannot :view_search, User                                                         # (Defined below)
    cannot :manage_assessment, User                                                   # (Defined below)
    cannot :request_access_to_vendor, User                                            # (Defined below)
    cannot :view_certificate_letter, User                                             # (Defined below)
    cannot :assign_mpp_role, User                                                     # (Defined below)

    # Case Review related permissions
    cannot :assign_or_change_case_review_analyst, User                                # (Defined below)
    cannot :assign_or_change_case_review_supervisor, User                             # (Defined below)
    cannot :assign_or_change_current_case_reviewer, User                              # (Defined below)
    cannot :make_case_review_determination, User                                      # (Defined below)
    cannot :change_decision_after_determination_made, User                            # (Defined below)
    cannot :change_assignments_on_review_with_determination_made_status, User         # (Defined below)
    cannot :change_owner_after_review_start, User                                     # (Defined below)
    cannot :change_supervisor_after_review_start, User                                # (Defined below)

    cannot :view_vendor_permissions_list, User                                        # (Defined below)
    cannot :assign_vendor_role, User                                                  # (Defined below)
    cannot :assign_analyst_role, User
    can :change_assignment, User
    cannot :ensure_supervisor, User
    cannot :ensure_ops_support, User                                                  # (Defined below)
    cannot :view_analyst_cases, User                                                  # (Defined below)
    cannot :assign_8a_role, User                                                      # (Defined below)
    cannot :assign_wosb_role, User                                                    # (Defined below)
    cannot :assign_mpp_role, User                                                     # (Defined below)
    cannot :start_review, User
    cannot :contribute, User                                                          # This is the role of a contributor to an application

    # New stuff for 8a
    cannot :ensure_8a_initial_sba_analyst, User
    cannot :ensure_8a_initial_sba_supervisor, User
    cannot :view_8a_initial_sba_analyst_dashboard, User
    cannot :view_8a_initial_sba_supervisor_dashboard, User

    cannot :assign_8a_cases, User
    cannot :ensure_8a_user_cods, User
    cannot :ensure_cods_analyst, User

    cannot :assign_8a_role_hq_aa, User
    cannot :assign_8a_role_district_office, User
    cannot :assign_8a_role_hq_ce, User
    cannot :assign_8a_role_ops, User
    cannot :assign_8a_role_size, User
    cannot :assign_8a_role_hq_legal, User
    cannot :assign_8a_role_oig, User

    cannot :ensure_8a_role_district_office, User

    cannot :view_8a_migrated_sba_supervisor_dashboard, User
    cannot :trigger_reconsideration, User


    if user.has_role? :vendor_admin
      can :ensure_vendor, User                                                        # This allows a user to be a vendor and have the main vendor functionality
      can :view_business_profile, User                                                # This allows a user to view the buiness tile
      can :view_personal_profile, User                                                # This allows a user to be able to change his personal information
      can :work_on_edwosb_wosb_application, User                                      # This allows a user to work on a edwosbe or wosbe application
      can :view_document_library, User                                                # This allows a user to view the Document Library tile
      can :assign_vendor_role, User                                                   # This will allows a user to give grant permissions to another user.
      can :grant_access_to_vendor_profile, User                                       # This allows a vendor to grant access to someone (CO) to access their profile
      can :view_certificate_letter, User                                              # This allows a user to view the certificate letter
      can :view_vendor_permissions_list, User                                         # This give access to the page where all the vendor's staff list are listed with their permissions
      can :view_vendor_navbar, User
    end

    if user.has_role? :vendor_editor
      can :ensure_vendor, User                                                        # (Already define above)
      can :view_business_profile, User                                                # (Already define above)
      can :view_personal_profile, User                                                # (Already define above)
      can :work_on_edwosb_wosb_application, User                                      # (Already define above)
      can :view_document_library, User                                                # (Already define above)
      can :view_certificate_letter, User                                              # (Already define above)
      can :view_vendor_permissions_list, User                                         # (Already define above)
      can :view_vendor_navbar, User
    end

    if user.has_role? :contributor
      can :ensure_contributor, User                                                        # (Already define above)
      can :contribute, User                                                           # (Already define above)
      can :view_document_library, User
      can :view_vendor_navbar, User
    end

    if user.has_role? :sba_supervisor_wosb
      can :ensure_wosb_user, User                                                     # Ability that ensure that only a user is an WOBS user.
      can :assign_or_change_case_review_analyst, User                                 # Allow user to assign or change the case review analyst
      can :assign_or_change_case_review_supervisor, User                              # Allow user to assign or change the case review supervisor
      can :assign_or_change_current_case_reviewer, User                               # Allow user to assign or change the current reviewer
      can :change_owner_after_review_start, User                                      # Allow user to change the case owner after a review has started
      can :change_supervisor_after_review_start, User                                 # Allow user to change the case supervisor after a review has started
      can :make_case_review_determination, User                                       # Allow user to make a case review determination decision
      can :view_sba_analyst_dashboard, User                                           # This allows a user to view the SBA Analyst Dashbaord
      can :sba_user, User                                                             # This give the SBA basic permissions to a User
      can :view_vendor_individual_profile, User                                       # This allows a user to view the profile of a user
      can :manage_assessment, User                                                    # This allows a user to make assessments
      can :view_search, User                                                          # This allowa a user to view and send data to the search method
      can :view_vendor_dashboard, User                                                # This allows a user to view the dashboard
      can :view_vendor_profile, User                                                  # This allows a user to view a vendor profile
      can :view_vendor_certification, User                                            # This allows to view a user certification
      can :view_vendor_documents, User                                                # This allows a user to view a vendor document
      can :view_vendor_case, User                                                     # This allows a user to view a vendor case
      can :view_vendor_application, User                                              # This allows a user to view a vendor application
      can :view_certificate_letter, User                                              # (Already define above)
      can :assign_analyst_role, User                                                  # This only allows a user to see the management link ( to get to the roles granting page)
      can :ensure_supervisor, User
      can :view_analyst_cases, User                                                   # This shows the cases link.
      can :assign_wosb_role, User                                                     # This is the role that will be used to display WOSB list of users on the table.
      can :start_review, User                                                         # This allow a user to start a review by clicking the link on the all cases page + protect the controller.
    end

    if user.has_role? :sba_analyst_wosb
      can :ensure_wosb_user, User                                                     # (See WOSB ability of same name)
      can :assign_or_change_case_review_analyst, User                                 # Allow user to assign or change the case review analyst
      can :assign_or_change_current_case_reviewer, User                               # (Already define above)
      can :assign_or_change_case_review_supervisor, User                              # Allow user to assign or change the case review supervisor
      can :view_sba_analyst_dashboard, User                                           # This allows a user to view the SBA Analyst Dashbaord
      can :sba_user, User                                                             # This give the SBA basic permissions to a User
      can :view_vendor_individual_profile, User                                       # This allows a user to view the profile of a user
      can :manage_assessment, User                                                    # This allows a user to make assessments
      can :view_search, User                                                          # This allowa a user to view and send data to the search method
      can :view_vendor_dashboard, User                                                # This allows a user to view the dashboard
      can :view_vendor_profile, User                                                  # This allows a user to view a vendor profile
      can :view_vendor_certification, User                                            # This allows to view a user certification
      can :view_vendor_documents, User                                                # This allows a user to view a vendor document
      can :view_vendor_case, User                                                     # This allows a user to view a vendor case
      can :view_vendor_application, User                                              # This allows a user to view a vendor application
      can :change_assignment, User                                                    # This allows a user to change the assignment of a case review
      can :view_certificate_letter, User                                              # (Already define above)
      can :view_analyst_cases, User                                                   # (Already define above)
      can :start_review, User
    end

    if user.has_role? :sba_supervisor_mpp
      can :ensure_mpp_user, User                                                      # Ability that ensure that only a user is an mpp user.
      can :assign_or_change_case_review_analyst, User                                 # (See WOSB ability of same name)
      can :assign_or_change_case_review_supervisor, User                              # (See WOSB ability of same name)
      can :assign_or_change_current_case_reviewer, User                               # (Already define above)
      can :make_case_review_determination, User                                       # (Already define above)
      can :change_owner_after_review_start, User                                      # Allow user to change the case owner after a review has started
      can :change_supervisor_after_review_start, User                                 # Allow user to change the case supervisor after a review has started
      can :view_sba_analyst_dashboard, User                                           # (Already define above)
      can :sba_user, User                                                             # (Already define above)
      can :view_vendor_individual_profile, User                                       # (Already define above)
      can :manage_assessment, User                                                    # (Already define above)
      can :view_search, User                                                          # (Already define above)
      can :view_vendor_dashboard, User                                                # (Already define above)
      can :view_vendor_profile, User                                                  # (Already define above)
      can :view_vendor_certification, User                                            # (Already define above)
      can :view_vendor_documents, User                                                # (Already define above)
      can :view_vendor_case, User                                                     # (Already define above)
      can :view_vendor_application, User                                              # (Already define above)
      can :view_certificate_letter, User                                              # (Already define above)
      can :ensure_supervisor, User
      can :view_analyst_cases, User                                                   # (Already define above)
      can :assign_mpp_role, User
      can :start_review, User
    end

    if user.has_role? :sba_analyst_mpp
      can :ensure_mpp_user, User                                                      # (See MPP ability of same name)
      can :assign_or_change_current_case_reviewer, User                               # (Already define above)
      can :assign_or_change_case_review_analyst, User                                 # Allow user to assign or change the case review analyst
      can :assign_or_change_case_review_supervisor, User                              # Allow user to assign or change the case review supervi
      can :view_sba_analyst_dashboard, User                                           # (Already define above)
      can :sba_user, User                                                             # (Already define above)
      can :view_vendor_individual_profile, User                                       # (Already define above)
      can :manage_assessment, User                                                    # (Already define above)
      can :view_search, User                                                          # (Already define above)
      can :view_vendor_dashboard, User                                                # (Already define above)
      can :view_vendor_profile, User                                                  # (Already define above)
      can :view_vendor_certification, User                                            # (Already define above)
      can :view_vendor_documents, User                                                # (Already define above)
      can :view_vendor_case, User                                                     # (Already define above)
      can :view_vendor_application, User                                              # (Already define above)
      can :change_assignment, User                                                    # (Already define above)
      can :view_certificate_letter, User                                              # (Already define above)
      can :view_analyst_cases, User                                                   # (Already define above)
      can :start_review, User
    end

    if user.has_role? :sba_ops_support_staff
      can :ensure_ops_support, User                                                   #
      can :sba_user, User
      can :view_sba_analyst_dashboard, User                                           # (Defined below)
      can :view_search, User                                                          # (Already define above)
      can :view_vendor_individual_profile, User                                       # (Already define above)
      can :view_vendor_dashboard, User                                                # (Already define above)
      can :view_vendor_certification, User                                            # (Already define above)
      can :view_vendor_documents, User                                                # (Already define above)
      can :view_vendor_profile, User                                                  # (Already define above)
      can :view_vendor_application, User                                              # (Already define above)
      can :view_certificate_letter, User                                              # (Already define above)
    end

    if user.has_role? :sba_ops_support_admin
      can :sba_user, User
      can :ensure_ops_support, User                                                   #
      can :ensure_ops_support_admin, User                                             #
      can :view_sba_analyst_dashboard, User                                           # (Defined below)
      can :view_search, User                                                          # (Already define above)
      can :view_vendor_individual_profile, User                                       # (Already define above)
      can :view_vendor_dashboard, User                                                # (Already define above)
      can :view_vendor_certification, User                                            # (Already define above)
      can :view_vendor_documents, User                                                # (Already define above)
      can :view_vendor_profile, User                                                  # (Already define above)
      can :view_vendor_application, User                                              # (Already define above)
      can :view_certificate_letter, User                                              # (Already define above)
      can :mange_help_pages, User                                                     # This allow a user the write to Read, Update the help page
      can :view_analyst_cases, User
    end

    if user.has_role? :sba_analyst_8a
      can :ensure_8a_user, User                                                       # Ensure that we have an 8a user.
      can :assign_or_change_current_case_reviewer, User                               # (Already define above)
      can :assign_or_change_case_review_analyst, User                                 # Allow user to assign or change the case review analyst
      can :assign_or_change_case_review_supervisor, User                              # Allow user to assign or change the case review supervi
      can :view_sba_analyst_dashboard, User                                           # (Already define above)
      can :sba_user, User                                                             # (Already define above)
      can :view_vendor_individual_profile, User                                       # (Already define above)
      can :manage_assessment, User                                                    # (Already define above)
      can :view_search, User                                                          # (Already define above)
      can :view_vendor_dashboard, User                                                # (Already define above)
      can :view_vendor_profile, User                                                  # (Already define above)
      can :view_vendor_certification, User                                            # (Already define above)
      can :view_vendor_documents, User                                                # (Already define above)
      can :view_vendor_case, User                                                     # (Already define above)
      can :view_vendor_application, User                                              # (Already define above)
      can :change_assignment, User                                                    # (Already define above)
      can :view_certificate_letter, User                                              # (Already define above)
      can :view_analyst_cases, User                                                   # (Already define above)
    end

    if user.has_role? :sba_supervisor_8a
      can :ensure_8a_user, User                                                       # ( defined above )
      can :assign_8a_role, User                                                       # This allows people to grant roles
      can :assign_or_change_case_review_analyst, User                                 # (See WOSB ability of same name)
      can :assign_or_change_case_review_supervisor, User                              # (See WOSB ability of same name)
      can :assign_or_change_current_case_reviewer, User                               # (Already define above)
      can :make_case_review_determination, User                                       # (Already define above)
      can :change_owner_after_review_start, User                                      # Allow user to change the case owner after a review has started
      can :change_supervisor_after_review_start, User                                 # Allow user to change the case supervisor after a review has started
      can :view_sba_analyst_dashboard, User                                           # (Already define above)
      can :sba_user, User                                                             # (Already define above)
      can :view_vendor_individual_profile, User                                       # (Already define above)
      can :manage_assessment, User                                                    # (Already define above)
      can :view_search, User                                                          # (Already define above)
      can :view_vendor_dashboard, User                                                # (Already define above)
      can :view_vendor_profile, User                                                  # (Already define above)
      can :view_vendor_certification, User                                            # (Already define above)
      can :view_vendor_documents, User                                                # (Already define above)
      can :view_vendor_case, User                                                     # (Already define above)
      can :view_vendor_application, User                                              # (Already define above)
      can :view_certificate_letter, User                                              # (Already define above)
      can :ensure_supervisor, User
      can :view_analyst_cases, User                                                   # (Already define above)
    end

    if user.has_role? :federal_contracting_officer
      can :view_vendor_certification, User                                            # (Already define above)
      can :view_vendor_documents, User                                                # (Already define above)
      can :request_access_to_vendor, User                                             # Allow user to request access to a vendor's profile
      can :ensure_contracting_officer, User                                           # This is the base CO role.
    end

    if user.has_role? :certify_system_admin
      can :ensure_admin, User
    end

###########
########### NEW 8(a) permissions that will need adjustment overtime.
###########

    # List of common roles for all Analysts:
    if (user.has_role? :sba_analyst_8a_cods) ||
        (user.has_role? :sba_analyst_8a_size ) ||
        (user.has_role? :sba_analyst_8a_ops) ||
        ( user.has_role? :sba_analyst_8a_district_office ) ||
        ( user.has_role? :sba_analyst_8a_hq_legal ) ||
        ( user.has_role? :sba_analyst_8a_oig ) ||
        ( user.has_role? :sba_analyst_8a_hq_ce ) ||
        ( user.has_role? :sba_analyst_8a_hq_program)
      can :ensure_8a_initial_sba_analyst, User
      can :view_8a_initial_sba_analyst_dashboard, User
      can :ensure_8a_user_cods, User
      can :ensure_cods_analyst, User
      can :assign_or_change_current_case_reviewer, User
      can :assign_or_change_case_review_analyst, User
      can :assign_or_change_case_review_supervisor, User
      can :view_sba_analyst_dashboard, User
      can :sba_user, User
      can :view_vendor_individual_profile, User
      can :manage_assessment, User
      can :view_search, User
      can :view_vendor_dashboard, User
      can :view_vendor_profile, User
      can :view_vendor_certification, User
      can :view_vendor_documents, User
      can :view_vendor_case, User
      can :view_vendor_application, User
      can :change_assignment, User
      can :view_certificate_letter, User
      can :view_analyst_cases, User
      can :start_review, User
      can :ensure_8a_user, User
    end

    # List of common roles for all supervisors:
    # Refactoring what is in already in the system.
    if  ( user.has_role? :sba_supervisor_8a_cods) ||
        (user.has_role? :sba_supervisor_8a_hq_program) ||
        ( user.has_role? :sba_supervisor_8a_hq_aa) ||
        ( user.has_role? :sba_supervisor_8a_hq_ce ) ||
        ( user.has_role? :sba_supervisor_8a_ops) ||
        ( user.has_role? :sba_supervisor_8a_size) ||
        ( user.has_role? :sba_supervisor_8a_hq_legal ) ||
        ( user.has_role? :sba_supervisor_8a_oig )
      can :ensure_8a_initial_sba_supervisor, User
      can :assign_or_change_current_case_reviewer, User
      can :assign_or_change_case_review_analyst, User
      can :assign_or_change_case_review_supervisor, User
      can :view_sba_analyst_dashboard, User
      can :sba_user, User
      can :view_vendor_individual_profile, User
      can :manage_assessment, User
      can :view_search, User
      can :view_vendor_dashboard, User
      can :view_vendor_profile, User
      can :view_vendor_certification, User
      can :view_vendor_documents, User
      can :view_vendor_case, User
      can :view_vendor_application, User
      can :view_certificate_letter, User
      can :view_8a_initial_sba_supervisor_dashboard, User
      can :ensure_8a_user, User
    end

    if (user.has_role? :sba_supervisor_8a_cods)
      can :start_review, User
      can :change_assignment, User
      can :assign_8a_role_cods, User
      can :assign_8a_cases, User
      can :ensure_8a_user_cods, User
      can :view_analyst_cases, User
    end

    if (user.has_role? :sba_supervisor_8a_hq_program)
      can :assign_8a_role_hq_program, User
      can :make_case_review_determination, User
      can :change_owner_after_review_start, User
      can :change_supervisor_after_review_start, User
      can :ensure_supervisor, User
      can :view_analyst_cases, User
    end

    if ( user.has_role? :sba_supervisor_8a_hq_aa)
      can :assign_8a_role_hq_aa, User
      can :trigger_reconsideration, User
      can :view_analyst_cases, User
    end


    if ( user.has_role? :sba_analyst_8a_district_office )
      can :ensure_8a_role_district_office, User
    end

    if ( user.has_role? :sba_supervisor_8a_district_office ) ||
      ( user.has_role? :sba_director_8a_district_office) ||
      ( user.has_role? :sba_deputy_director_8a_district_office )
      can :view_analyst_cases, User
      can :assign_8a_role_district_office, User
      can :assign_8a_role_district_office_supervisor, User
      can :view_8a_migrated_sba_supervisor_dashboard, User
      can :assign_8a_cases, User
      can :assign_or_change_current_case_reviewer, User
      can :assign_or_change_case_review_analyst, User
      can :assign_or_change_case_review_supervisor, User
      can :view_sba_analyst_dashboard, User
      can :sba_user, User
      can :view_vendor_individual_profile, User
      can :manage_assessment, User
      can :view_search, User
      can :view_vendor_dashboard, User
      can :view_vendor_profile, User
      can :view_vendor_certification, User
      can :view_vendor_documents, User
      can :view_vendor_case, User
      can :view_vendor_application, User
      can :view_certificate_letter, User
      can :ensure_8a_user, User
      can :ensure_8a_role_district_office, User
    end

    if  ( user.has_role? :sba_director_8a_district_office ) ||
      ( user.has_role? :sba_deputy_director_8a_district_office )
      can :trigger_reconsideration, User
    end

    if ( user.has_role? :sba_supervisor_8a_hq_ce )
      can :assign_8a_role_hq_ce, User
      can :view_analyst_cases, User  
    end

    if ( user.has_role? :sba_supervisor_8a_ops)
      can :assign_8a_role_ops, User
    end

    if ( user.has_role? :sba_supervisor_8a_size)
      can :assign_8a_role_size, User
    end

    if ( user.has_role? :sba_supervisor_8a_hq_legal )
      can :assign_8a_role_hq_legal, User
    end

    if ( user.has_role? :sba_supervisor_8a_oig )
      can :assign_8a_role_oig, User
    end


  end
end

