class Us867SeedData < ActiveRecord::Migration
  def up
    title_panel = "Title panel"
    left_panel = "left panel"
    right_panel = "right panel"
    HelpPage.create!(title: title_panel, left_panel: left_panel, right_panel: right_panel)
  end

  def down
  end
end
