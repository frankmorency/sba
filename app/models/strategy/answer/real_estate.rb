module Strategy
  module Answer
    class RealEstate < Base
      attr_accessor :sub_questions

      def set_details
        @details_casted = []

        @answer = super
        @sub_questions = @answer.question.sub_questions

        @answer.details = []

        data.values.select {|v| v.is_a?(Hash) }.map {|h| h.values }.each do |fields|
          @answer.details << {}
          fields.each do |field|
            next unless field['question_name']
            @answer.details.last[field['question_name']] = field['value']
          end
        end

        groom_data

        validate_data

        @answer
      end

      def set_value
        assets, liabilities, income = 0, 0, 0

        @details_casted.each do |h|
          percent_mortgage_owned, mortgage, liens = h['real_estate_percent_of_mortgage'], h['real_estate_mortgage_balance'], h['real_estate_second_mortgage_value']

          liabilities += mortgage + liens # for edwosb we're not concerned with percent of mortgage owned

          assets += h['real_estate_value'] if h['real_estate_value']
          income += h['real_estate_rent_income_value'] if h['real_estate_rent_income_value']
        end

        @answer.value = {value: {assets: assets, liabilities: liabilities, income: income} }
      end

      private

      def validate_data

        @answer.details.each_with_index do |re|
          @details_casted << {}

          picklist = @sub_questions.find {|q| q.name == 'real_estate_type'}
          if picklist
            unless picklist.possible_values.include? re['real_estate_type']
              @errors << "Other real estate #{re['real_estate_type']} must be one of #{picklist.possible_values}"
            end
          end

          @sub_questions.each do |sub_question|
            strategy = sub_question.to_strategy(user, app_id, answered_for, re[sub_question.name])
            re[sub_question.name] = strategy.answer.display_value
            @details_casted.last[sub_question.name] = strategy.answer.casted_value
            raise strategy.to_error unless re['real_estate_second_mortgage'] == 'no' || re['real_estate_rent_income'] == 'no' || strategy.valid?
          end
        end
      end

      def groom_data
        # validate data fields (based on rules that can be used on the client side?)
        @answer.details.each do |re|
          if re['real_estate_jointly_owned'] != 'yes'
            re['real_estate_jointly_owned_percent'] = nil
            re['real_estate_percent_of_mortgage'] = nil
          end

          if re['real_estate_second_mortgage'] != 'yes'
            re['real_estate_second_mortgage_value'] = nil
            re['real_estate_second_mortgage_your_name'] = nil
            re['real_estate_second_mortgage_percent'] = nil
          elsif re['real_estate_second_mortgage_your_name'] != 'yes'
            re['real_estate_second_mortgage_percent'] = nil
          end

          if re['real_estate_rent_income'] != 'yes'
            re['real_estate_rent_income_value'] = nil
          end
        end

        @answer.details
      end
    end
  end
end
