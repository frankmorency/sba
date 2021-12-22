require 'new_relic/agent/method_tracer'

class SbaApplication::MasterApplication::Progress
  attr_accessor :user, :next_section, :skip_info, :sba_application, :section

  def self.advance!(app, user, section, answer_params = [])
    progress = new(app, user, section, answer_params)
    progress.update!
    [ progress.next_section, progress.skip_info ]
  end

  def initialize(app, user = nil, section = nil, answer_params = [])
    @sba_application, @user, @section, @answers = app, user, section, answer_params
    @tmp_cache = {}
  end

  def update!
    ActiveRecord::Base.transaction do
      # user.save! if user.changed?
      #
      # @next_section, @skip_info = @section.next_section(user, sba_application.id)
      # update_progress section, next_section, skip_info
      # sba_application.save!
    end
  end

end
