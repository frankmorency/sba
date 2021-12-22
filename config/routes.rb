require "api_constraints"

Rails.application.routes.draw do
  resources :contributors, only: [:create, :destroy] do
    collection do
      post "reminder"
      post "reminder_complete_app"
      get "done"
    end
  end

  get "notes_controller/create"

  ckeditor_web_constraint = lambda do |request|
    current_user = request.env["warden"].user
    current_user.present? && current_user.can?(:mange_help_pages)
  end

  constraints ckeditor_web_constraint do
    mount Ckeditor::Engine => "/ckeditor"
  end

  resources :help_pages, only: [:index] do
    constraints ckeditor_web_constraint do
      collection do
        get "edit" => "help_pages#edit"
        patch "update" => "help_pages"
      end
    end
  end

  devise_for :users, controllers: {
                       omniauth_callbacks: "users/omniauth_callbacks",
                       sessions: "users/sessions",
                       registrations: "users/registrations",
                       passwords: "users/passwords",
                       confirmations: "users/confirmations",
                     }

  devise_scope :user do
    namespace :vendor_admin do
      resources :my_profile, only: [:index] do
        get "edit_profile", to: "/users/registrations#edit", as: "edit_profile", on: :collection
        get "edit_passphrase", to: "/users/registrations#edit", as: "edit_passphrase", on: :collection
      end
    end

    post "users/registrations/step2", to: "users/registrations#step2", as: "step_2"
    get "users/registrations/confirmation", to: "users/registrations#confirmation", as: "registration_confirmation"
    get "users/passwords/reset_password_instructions_confirmation", to: "users/passwords#reset_password_instructions_confirmation", as: "reset_password_instructions_confirmation"
    get "users/passwords/reset_password_confirmation", to: "users/passwords#reset_password_confirmation", as: "reset_password_confirmation"
    post "/password_strength", to: "users/passwords#strength"
    post "/is_strong", to: "users/passwords#is_strong"
    # SAML Auth routes
    post "/auth/:provider/callback" => "users/omniauth_callbacks#saml"
    get "/signin" => "users/sessions#new_saml", :as => :signin
    get "/max_gov", to: "users/sessions#max_gov", as: "max_gov"
    get "welcome_to_sba", to: "users#welcome_to_sba"
    post "request_vendor_role", to: "users#request_vendor_role"
    if Feature.active?(:idp)
      delete "sign_out", :to => "devise/sessions#destroy", :as => :destroy_user_session
    end
    get "vendor_login_landing", :to => "users/sessions#vendor_login_landing"
    get "max_login_landing", :to => "users/sessions#max_login_landing"
    get "idp_stubbed_login_form", :to => "users/sessions#idp_stubbed_login_form"
    post "idp_stubbed_login", :to => "users/sessions#idp_stubbed_login"
  end

  resque_web_constraint = lambda do |request|
    current_user = request.env["warden"].user
    current_user.present? && current_user.can?(:ensure_admin)
  end

  constraints resque_web_constraint do
    mount ResqueWeb::Engine => "/resque_web"
  end

  root to: "pages#show", id: "home"

  # Static Pages

  match "/help" => redirect("https://sbaone.atlassian.net/servicedesk/customer/portal/6"), as: "help", via: [:get]
  get "/8a-docs" => "eightadocs#index"
  get "/certify-help" => "certify_help#index"
  post "/certify-help" => "certify_help#create"

  get "/am-i-eligible/app" => "custom/am_i_eligible#new"
  get "/am-i-eligible" => "custom/am_i_eligible#new"
  get "/gls_redirect" => "pages#show", id: "gls_redirect"

  get "/test_exception_notifier", controller: "application", action: "test_exception_notifier"

  get "/prepare", to: "custom/am_i_eligible#prepare", as: "prepare"
  post "/am-i-eligible/email", to: "custom/am_i_eligible#email", as: :send_eligibility_results_email

  get "my_profile", to: "dashboard#my_profile", as: "my_profile"

  post "/associate_business", to: "users#associate_business", as: "associate_business"
  match "/find_business", to: "users#find_business", as: "find_business", via: [:get, :post]
  match "/request_role", to: "max_users#request_role", as: "request_role", via: [:get, :post]
  match "/assign_role", to: "max_users#assign_role", as: "assign_role", via: [:post]
  match "/next_page", to: "max_users#next_page", as: "next_page", via: [:post]

  resources :dashboard

  resources :my_documents, only: [:index]

  resources :certificate_types, only: [:index] do
    resources :sba_applications, only: [:new, :show]
    resources :application_types, only: [] do
      resources :sba_applications, only: [:new, :create]
    end
  end

  resources :organizations, only: [] do
    resources :documents, only: [] do
      member do
        get "pdf_viewer"
        get "download_file"
      end
    end
  end

  namespace :answers do
    resources :data_entry_grid, only: [] do
      collection do
        post "contracts_awarded"
        delete "destroy_contract"
      end
    end
  end

  resources :documents do
    collection do
      post "review_upload"
      post "upload"
      post "attach"
      post "update_comment"
    end
  end

  resources :sba_applications do
    member do
      get "fill"
      get "create_annual_review"
    end
  end

  resources :organizations, only: [] do
    # resources :sba_applications, only: [:show]
    resources :certificate, only: [:show], via: [:get, :post]
    resources :adverse_action_reviews, only: [:show, :new, :create] do
      resources :notes, only: [:index, :create], controller: "application_dashboard/notes"
      resources :analyst_documents, only: [:index], controller: "application_dashboard/analyst_documents"
    end
  end

  resources :master_applications, only: [] do
    resources :sections, only: [] do
      resources :questionnaires, only: [] do
        resources :sba_applications, only: [:new, :create, :show]
        resources :contributor_sections, only: [] do
          resources :sba_applications, only: [:new, :create]
        end
      end
    end
  end

  resources :questionnaires, only: [:show] do
    resources :sba_applications, only: [:new]
    resources :organizations, only: [] do
      resources :sba_applications, only: [:show]
    end

    resources :roots, controller: "section/question_sections", only: [:edit, :update]
    resources :question_sections, controller: "section/question_sections", only: [:edit, :update]
    resources :repeating_question_sections, controller: "section/repeating_question_sections", only: [:edit, :update]
    resources :composite_question_sections, controller: "section/composite_question_sections", only: [:edit, :update]
    resources :review_sections, controller: "section/review_sections", only: [:edit, :update]
    resources :signature_sections, controller: "section/signature_sections", only: [:edit, :update]
    resources :spawners, controller: "section/spawners", only: [:edit, :update]
    resources :master_application_sections, controller: "section/master_application_sections", only: [:edit, :update]
  end

  resources :sba_applications, except: [:new, :create] do
    resources :deficiency_letter, controller: "reviews/deficiency_letter"
    resources :return_master_application, controller: "reviews/return_master_application"

    resources :conversations do
      resources :messages
    end
    get "check_notifications", to: "notifications#check_notifications"
    get "update_status", to: "notifications#update_status"
    get "notifications/check_for_new", to: "notifications#check_for_new"
    resources :notifications

    resources :section, only: [] do
      resources :contributors, only: [:create, :destroy]
      resources :questions, only: [] do
        resources :question_presentations, only: [:new]
      end
    end
    resources :questionnaires, only: [:show] do
      resources :question_sections, controller: "section/question_sections", only: [:edit, :update]
      resources :real_estate_sections, controller: "section/real_estate", only: [:edit, :update]
      resources :real_estates, controller: "section/real_estate", only: [:edit, :update]
      resources :repeating_question_sections, controller: "section/repeating_question_sections", only: [:edit, :update]
      resources :composite_question_sections, controller: "section/composite_question_sections", only: [:edit, :update]
      resources :review_sections, controller: "section/review_sections", only: [:edit, :update]
      resources :signature_sections, controller: "section/signature_sections", only: [:edit, :update]
      resources :spawners, controller: "section/spawners", only: [:edit, :update]
      resources :personal_summaries, controller: "section/personal_summaries", only: [:edit, :update]
      resources :personal_privacies, controller: "section/personal_privacy", only: [:edit, :update]
      resources :master_application_sections, controller: "section/master_application_sections", only: [:edit, :update]
      resources :contributor_sections, controller: "section/contributor_sections", only: [:edit, :update]
    end

    resources :adhoc_reviews
  end

  namespace :custom do
    resources :am_i_eligible, only: [:new, :create]
  end

  resources :reviews, only: [] do
    resources :refer_case, controller: "reviews/refer_case"
    resources :refer_case_within_sba, controller: "reviews/refer_case_within_sba"
    resources :initiate_adverse_action, controller: "reviews/initiate_adverse_action"
    resources :finalize_adverse_action, controller: "reviews/finalize_adverse_action"
    resources :begin_processing, controller: "reviews/begin_processing"
    resources :reassign_annual_review, controller: "reviews/reassign_annual_review"
    resources :reassign_case, controller: "reviews/reassign_case"
    resources :retain_firm, controller: "reviews/retain_firm"
    resources :make_recommendations, controller: "reviews/make_recommendation"
    resources :make_determinations, controller: "reviews/make_determinations"
    resources :request_adhoc_review, controller: "reviews/request_adhoc_review"
    resources :intent_to_terminate_letter, controller: "reviews/intent_to_terminate_letter"
    resources :close_case, controller: "reviews/close_case"
    resources :cancel_case, controller: "reviews/cancel_case"
    resources :return_to_case_owner, controller: "reviews/return_to_case_owner"
    resources :indicate_receipt, controller: "reviews/indicate_receipt"
  end

  namespace :program do
    resources :request_for_info
  end

  namespace :sba_analyst do
    resources :agency_requirements do
      get :download
      collection do
        get "get_agency_naics"
        get "get_duns"
        get "delete_firm"
      end
      member do
        get "firms"
        get "add_firm"
      end
      resources :agency_requirement_documents, only: [:new, :create, :destroy] do
        get :download
      end
      resources :agency_requirement_organizations, only: [:new, :create, :destroy]
    end

    resources :agency_requirements_search do
      collection do
        get :download
        post "search"
      end
    end

    resources :profile, only: [:index]

    resources :cases, only: [:index] do
      collection do
        get "/eight_a" => "cases#eight_a"
        get "/mpp" => "cases#mpp"
        get "/wosb" => "cases#wosb"
        get "/voluntary_suspension" => "cases#voluntary_suspension"
        get "/all_cases" => "cases#index"
        post "all_cases_search"
        post "search"
        get "declined"
        get "returned"
        get :download
      end
    end

    resources :voluntary_suspensions, only: [:show, :update]

    resources :role_access_requests, only: [:new, :index, :create] do
      post "request"
      put :accept
      put :reject
      put :revoke
    end

    resources :reviews, except: :show do
      resources :assessments, only: :create
      resources :notes, only: [:create]
    end

    resources :annual_reports do
      member do
        post :return_to_vendor
        post :approve
        post :decline
      end
    end

    resources :certificates, only: [:edit, :update] do
      resources :sba_applications, only: [] do
        resources :revisions, only: :index
      end
    end

    resources :organizations, only: [] do
      match "/dashboard", to: "dashboard#show", as: "org_dashboard_show", via: :get
    end

    resources :sba_applications, only: [] do
      resources :dashboard, only: [] do
        collection do
          get :return_for_modification
          get :download_zip
          get :generate_zip
          get :create_8a_annual_review
        end
      end

      resources :reviews, only: [:new, :index, :create]
      resources :revisions, only: :index
    end

    resources :reviews, except: [:new, :create] do
      resources :question_reviews, only: :new
      resources :financial_reviews, only: :new
      resources :signature_reviews, only: :new
      resources :determinations
      resources :sba_applications, only: [] do
        resources :revisions, only: :index
      end
    end

    match "/dashboard", to: "dashboard#index", as: "dashboard_index", via: [:get, :post]
    match "/dashboard/organization", to: "dashboard#show", as: "dashboard_show", via: [:get, :post]
  end

  namespace :admin do
    resources :document_types, only: [:index]
    resources :dashboard, only: [:index]
    resources :permissions, only: [:index]
    resources :questionnaires, only: [:index]
    resources :questions, only: [:index]
    resources :sections, only: [:index]
    resources :workflow_states, only: [:index]
    resources :question_types, only: [:index]
    resources :sba_users, only: [:index]
    resources :users, only: [:index] do
      resources :roles
    end
    resources :data_dictionary, only: [:index] do
      collection do
        get :csv_download
        get :csv_download_all
      end
    end

    get "unclaimed_business", to: "unclaimed_business#index"
  end

  namespace :vendor_admin do
    match "/apps", to: "apps#index", via: [:get] # This is to be removed. for testing only BRUNO-MESSAGING

    resources :role_access_requests, only: [:new, :create] do
      post "search", on: :collection
      put :accept
      put :reject
      put :revoke
    end
    resources :access_requests, only: [:index] do # needs to be nested under organizations
      put :accept
      put :reject
      put :revoke
    end
    resources :dashboard, only: [:index]
    resources :my_businesses, only: [:index]
    resources :my_certifications, only: [:index]
    resources :my_profile, only: [:index]
    resources :my_documents, only: [:index] do
      put :archive
      put :restore
      get "inactive", on: :collection
    end
    resource :voluntary_suspension do
      get :download
    end
    resources :voluntary_suspension_cancels, only: %i(update)
  end

  resources :sba_application, only: [:index] do
    namespace :application_dashboard do
      resources :sub_applications, only: [:show]
      resources :overview, only: [:index] do
        collection do
          post "assign_servicing_bos"
          post "assign_duty_station"
          get "edit_duty_station"
          get "edit_servicing_bos"
          get "section_info"
        end
      end
      resources :firm_documents, only: [:index] do
        collection do
          post :user_filter
        end
      end
      resources :analyst_documents, only: [:index]
      resources :notes, only: [:index, :create]
      resources :activity_log do
        collection do
          get "export"
        end
      end
      resources :bdmis_history, only: [:index] do
        collection do
          get "view_file"
        end
      end
      resources :sub_applications, only: [] do
        resources :adhoc_questionnaires, only: [:index, :show]
        resources :reconsideration_questionnaires, only: [:index, :show] do
          collection do
            get "appeal_or_reconsideration"
            get "intend_to_appeal"
            get "appeal_reminder"
            post "appeal_or_reconsider"
            post "intent_acknowledgment"
          end
        end
      end
    end
  end

  namespace :eight_a_initial_sba_supervisor do
    resources :dashboard, only: [:index] do
      collection do
        get "assign"
        get "hide_info_request"
        post "create_assignment"
      end
    end

    get "check_notifications", to: "notifications#check_notifications"
    get "update_status", to: "notifications#update_status"
    get "notifications/check_for_new", to: "notifications#check_for_new"
    resources :notifications
  end

  namespace :district_office_sba_supervisor do
    resources :dashboard, only: [:index] do
      collection do
        get "assign"
        get "hide_info_request"
        post "create_assignment"
      end
    end

    get "check_notifications", to: "notifications#check_notifications"
    get "update_status", to: "notifications#update_status"
    get "notifications/check_for_new", to: "notifications#check_for_new"
    resources :notifications
  end

  get "check_notifications", to: "notifications#check_notifications"
  get "update_status", to: "notifications#update_status"
  get "notifications/check_for_new", to: "notifications#check_for_new"
  resources :notifications

  namespace :eight_a_initial_sba_analyst do
    resources :dashboard, only: [:index] do
      collection do
        get "hide_info_request"
      end
    end

    get "check_notifications", to: "notifications#check_notifications"
    get "update_status", to: "notifications#update_status"
    get "notifications/check_for_new", to: "notifications#check_for_new"
    resources :notifications
  end

  namespace :ops_support do
    resources :user, only: [:index, :show, :create] do
      delete :desassociate_organization
      post :reset
    end
    resources :organizations, only: [:update, :show]
    resources :bdmis, only: [:index, :show] do
      member do
        get :re_import
      end
    end
    resources :sam_validation, only: [:index, :show] do
      collection do
        post :validate
      end
    end
    resources :people do
      collection do
        resources :people_requests, :path => 'requests'
      end
    end
  end

  namespace :contracting_officer do
    root to: "dashboard#index"
    resources :access_requests do
      post "search", on: :collection
    end
    resources :organizations, only: [] do
      resources :sba_applications, only: [:show]
      resources :certificate, only: [:show], via: [:get, :post]
    end
  end

  namespace :api, :defaults => { :format => "json" } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, :default => true) do
      resources :duns_numbers, only: [:show]
      resources :certifications, only: [:index]
    end
  end
end
