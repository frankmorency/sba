module Spec
  module Fixtures
    class SampleApplication
      def self.load(user, certificate_type, status, versions = 1)
        @user = user
        @sba_application = SbaApplication::SimpleApplication.new(questionnaire_id: certificate_type.initial_questionnaire.id, organization: user.one_and_only_org)
        @sba_application.current_user = @user
        @sba_application.save!

        if versions > 1
          answer_all_questions @user, @sba_application
          @sba_application.submit!

          new_version = @sba_application.return_for_modification

          (versions - 1).times.each do
            new_version.submit!
            new_version.reload
            new_version = new_version.return_for_modification
          end

          @sba_application = new_version
        end

        case status
          when :answered
            answer_all_questions @user, @sba_application
          when :submitted, :pending
            answer_all_questions @user, @sba_application
            @sba_application.submit!
        end

        @sba_application
      end

      def self.answer_all_questions(user, app)
        answer_params = {
            "#{qid('must_answer_yes')}" => {value: "yes"},
            "#{qid('must_answer_no')}" => {value: "no"},
            "#{qid('is_it_big')}" => {value: "yes"},
            "#{qid('do_you_mean_it')}" => {value: "yes"},
            "#{qid('do_you_like_it')}" => {value: "yes"}
        }

        user.set_answers answer_params, sba_application: app
      end

      def self.qid(name)
        Question.get(name).id
      end
    end
  end
end
