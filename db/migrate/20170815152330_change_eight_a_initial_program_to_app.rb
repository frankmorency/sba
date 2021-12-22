class ChangeEightAInitialProgramToApp < ActiveRecord::Migration
  def change
    
    Questionnaire.find_by(name: 'eight_a_initial').update_attributes title: "8(a) Initial Application", link_label: "8(a) Initial Application"
  end
end
