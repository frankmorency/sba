module Strategy
  module Answer
    class DateRange < Base
           
      def validate           
        end_date = DateTime.strptime(value["end_date"], '%m/%d/%Y')        
        start_date = DateTime.strptime(value["start_date"], '%m/%d/%Y')
        @errors << 'The start date should come before the end date' if start_date > end_date
      end

      def any_nil?(start_month, end_month, start_day, end_day, start_year, end_year)
        start_month.nil? || end_month.nil? || start_day.nil? || end_day.nil? || start_year.nil? || end_year.nil?
      end

      def all_integers?(start_month, end_month, start_day, end_day, start_year, end_year)
        start_month.is_a?(Integer) && end_month.is_a?(Integer) && start_day.is_a?(Integer) && end_day.is_a?(Integer) && start_year.is_a?(Integer) && end_year.is_a?(Integer)
      end

      def valid_month?(month)
        month.between?(QuestionType::DateRange::DEFAULT_MIN_MONTH_VALUE, QuestionType::DateRange::DEFAULT_MAX_MONTH_VALUE)
      end

      def valid_day?(day)
        day.between?(QuestionType::DateRange::DEFAULT_MIN_DAY_VALUE, QuestionType::DateRange::DEFAULT_MAX_DAY_VALUE)
      end

      def valid_year?(year)
        year.between?(QuestionType::DateRange::DEFAULT_MIN_YEAR_VALUE, QuestionType::DateRange::DEFAULT_MAX_YEAR_VALUE)
      end

    end
  end
end