class ChangeIraQuestionStrategy < ActiveRecord::Migration
  def change
        Question.find_by(name: 'roth_ira').update_attribute('strategy','RothIRARetirement')
  end
end
