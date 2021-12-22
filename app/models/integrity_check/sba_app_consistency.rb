module IntegrityCheck
  class SbaAppConsistency
      extend Resque::Plugins::Retry

    @queue = :integrity_check
    @retry_limit = 2
    @retry_delay = 20

    attr_accessor :original_app, :new_app

    def self.perform(original_app_id, new_app_id)
        original_app, new_app = SbaApplication.find [original_app_id, new_app_id]
        new(original_app, new_app).check_sameness!
      rescue Resque::TermException
        Resque.enqueue(self, args)
    end

    def initialize(original_app, new_app)
      @original_app, @new_app = original_app, new_app
      self
    end

    def check_sameness!
      Rails.logger.warn("BATCH INTEGRITY CHECK: SBA APP CONSISTENCY [#{original_app.id}, #{new_app.id}]")
      sections_missing = original_app.section_debug - new_app.section_debug
      extra_sections = new_app.section_debug - original_app.section_debug
      section_rule_diff = Diffy::Diff.new(original_app.section_rule_debug, new_app.section_rule_debug).to_s
      section_counts = [original_app.every_section.count, new_app.every_section.count]
      section_rule_counts = [original_app.every_section_rule.count, new_app.every_section_rule.count]
      tree_diff = Diffy::Diff.new(JSON.pretty_generate(original_app.root_section.arrangement(false)), JSON.pretty_generate(new_app.root_section.arrangement(false))).to_s
      answer_counts = [original_app.answers.count, new_app.answers.count]

      success = tree_diff.empty? && sections_missing.empty? && extra_sections.empty? && section_rule_diff.blank? && section_counts.first == section_counts.last || section_rule_counts.first == section_rule_counts.last || answer_counts.first == answer_counts.last

      unless success
        ExceptionNotifier.notify_exception(
            Error::IntegrityCheckFailed.new,
            data: {
                message: "Application ##{id} versus ##{new_app.id}: section counts => #{section_counts} section rule counts => #{section_rule_counts} answer counts => #{answer_counts}\n\nMissing Sections: #{sections_missing.join(", ")}\nExtra Sections: #{extra_sections.join(", ")}\n\nSection Rule Diff:\n#{section_rule_diff}\n\nSection Tree Diff:\n#{tree_diff}\n"
            }
        )
      end

      Rails.logger.warn("BATCH INTEGRITY CHECK: SBA APP CONSISTENCY COMPLETE")
    end
  end
end
