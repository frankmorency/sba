module Answers
  class DataEntryGridController < AnswersController
    before_action :require_vendor_or_contributor
    before_action :set_answer
    before_action :require_answer_belongs_to_application_by_user, if: :answer_exists

    def destroy_contract
      deletions = 0
      unless @answer.nil?
        @answer.value['value'].each do |key, answer_row|
          next if deletions > 0
          if items_match?(answer_row, params[:item])
            @answer.value['value'].delete(key)
            @answer.update_attributes(value: @answer.value)
            deletions+=1
          end
        end
      end

      render json: '', :status => 200
    end

    def contracts_awarded
      array = []
      unless @answer.nil?
        @answer.value['value'].each do |answer_row|
          array << {
              "Award date":answer_row[1]['award_date'].to_s,
              "Agency or customer name":answer_row[1]['agency_customer_name'].to_s,
              "NAICS code":answer_row[1]['naics_code'].to_s,
              "Description of Work":answer_row[1]['description'].to_s,
              "Value":answer_row[1]['value']
          }
        end
      end
      render json: array
    end

    protected

    def require_vendor_or_contributor
      user_not_authorized unless current_user.is_vendor_or_contributor?
    end

    def require_answer_belongs_to_application_by_user
      application = SbaApplication.find_by_id(@answer.sba_application_id)

      user_not_authorized unless application&.creator_id == current_user.id
    end

    private

    def set_answer
      @answer = Answer.where(sba_application_id: params[:sba_application_id]).where(question_id: params[:question_id]).where(owner_id: params[:owner_id]).take
    end

    def answer_exists
      !@answer.nil?
    end

    def items_match?(db_item, client_item)
      db_item['award_date'].to_s == client_item[:award_date] &&
          db_item['agency_customer_name'].to_s == client_item[:agency_customer_name] &&
          db_item['naics_code'].to_s == client_item[:naics_code] &&
          db_item['description'].to_s == client_item[:description] &&
          db_item['value'].to_s == client_item[:value]
    end
  end
end
