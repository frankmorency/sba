class AvStatusHistory < ActiveRecord::Base
  acts_as_paranoid
  # has_paper_trail

  self.table_name = "av_status_history"
end
