class Section
  class BaseController < ApplicationController
    include ApplicationHelper

    before_action :set_questionnaire
    before_action :authenticate_user!, unless: :anonymous_questionnaire?
    before_action :ensure_sba_or_vendor, only: [:update, :edit], unless: :anonymous_questionnaire?
    before_action :set_application, only: [:update, :edit], unless: :anonymous_questionnaire?

    before_action :ensure_contributor_can_access, only: [:update, :edit], unless: :anonymous_questionnaire?

    before_action :set_section, only: [:edit, :update]
    before_action :set_user_and_check_draft, only: [:edit, :update]
    before_action :set_questionnaire_layout
    before_action :check_eight_a_feature

    layout :determine_layout

    def edit
      if @sba_application
        @sba_application.progress['current'] = @section.name
        @sba_application.save!
      end
    end

    def update
      unless can?(:ensure_vendor, current_user) || can?(:ensure_contributor, current_user)
        user_not_authorized
      else
        @next_section, @skip_info = @sba_application.advance!(@user, @section, answer_params)

        if @next_section
          redirect_to section_path_helper(@sba_application, @next_section, true)
        elsif @sba_application.is_a?(SbaApplication::SubApplication)
          redirect_to section_path_helper(@sba_application.master_application, @sba_application.master_application.first_section, true)
        else
          redirect_to vendor_admin_dashboard_index_path
        end
      end
    end

    protected

    def set_permissions
      @permissions = Permissions.build(current_user, @sba_application.current_review)
    end

    def set_user_and_check_draft
      set_user
      check_draft
    end

    def check_draft
      return true if @questionnaire.anonymous?

      return true if @sba_application.drafty?

      flash[:notice] = 'Error: Application is not in Draft state'
      redirect_to vendor_admin_dashboard_index_path
      false
    end


    def answer_params
      []
    end

    private

    def set_questionnaire_layout
      @questionnaire_layout = true
    end

    def set_user
      if @questionnaire.anonymous?
        @user = AnonymousUser.new
      else
        @user = current_user
      end
    end

    def javascript_options
      options = {
          rules: {},
          messages: {},
          errorElement: "span",
          ignore: []
      }

      @questions.each do |question|        
        unless question.not_required?
          options[:rules][question.dom_id] = question.question_type.validation_settings[:rules] unless question.question_type.type == 'QuestionType::Checkbox'
          options[:messages][question.dom_id] = question.question_type.validation_settings[:messages] unless question.question_type.type == 'QuestionType::Checkbox'

          # TODO: This is added to validate details field for quetsion type. Should be made generic.
          if question.question_type.type == 'QuestionType::Table'
            options[:rules][question.dom_id('details')] = question.question_type.additional_validation_settings(question)[:rules]
            options[:messages][question.dom_id('details')] = question.question_type.additional_validation_settings(question)[:messages]

          end

          if question.question_type.type == 'QuestionType::DateRange'                   
            options[:rules][question.dom_id('error')] = question.question_type.validation_settings[:rules]
            options[:rules][question.dom_id('start_date')] = question.question_type.validation_settings[:rules]
            options[:rules][question.dom_id('end_date')] = question.question_type.validation_settings[:rules]
            options[:messages][question.dom_id('error')] = question.question_type.validation_settings[:messages]
            options[:messages][question.dom_id('start_date')] = question.question_type.validation_settings[:messages]
            options[:messages][question.dom_id('end_date')] = question.question_type.validation_settings[:messages]            
          end

          if question.question_type.type == 'QuestionType::Checkbox'
            options[:rules][question.dom_id+'[]'] = question.question_type.validation_settings[:rules]
            options[:messages][question.dom_id+'[]'] = question.question_type.validation_settings[:messages]
          end
        end

        question.rules.each do |rule|        
          options[:rules][rule.dom_id(question)] = rule.validation_settings(question)[:rules]
          options[:messages][rule.dom_id(question)] = rule.validation_settings(question)[:messages]
        end
      end

      options
    end

    def destroy_document_associations(sba_application_id, document_ids)
      document_ids.each do |document_id|
        SbaApplicationDocument.find_by(sba_application_id: sba_application_id, document_id: document_id).destroy
      end
    end

    def section_id
      params.require(:id)
    end

    # UX-TODO: come back and work on this
    def determine_layout
      if (can?(:sba_user, current_user) || can?(:ensure_ops_support, current_user))
        'read_only'
      else
        'application'
      end
    end

    def set_real_estate_type
      @real_estate_type = nil

      if @section.name =~ /^real_estate_other/
        @real_estate_type = 'other_real_estate'
      elsif @section.name =~ /^real_estate_primary/
        @real_estate_type = 'primary_real_estate'
      end
    end

  end
end
