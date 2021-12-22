class ChangeEightAAppClass < ActiveRecord::Migration
  def change
    SbaApplication::MasterApplication.update_all type: 'SbaApplication::EightAMaster'
  end
end
