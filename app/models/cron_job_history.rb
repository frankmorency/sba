class CronJobHistory < ActiveRecord::Base
  validates :type, presence: true

  def start!
    update_attributes!(start_time: Time.now)
  end

  def stop!
    update_attributes!(end_time: Time.now)
  end
end
