class AddParentFlagsToSection < ActiveRecord::Migration
  def change
    add_column :sections, :sub_sections_completed, :boolean, default: false # used to determine whether to show a green checkmark in the questionnaire side nav
    add_column :sections, :sub_sections_applicable, :boolean, default: true # used to determine whether to gray out the section in the questionnaire side nav

    Section.reset_column_information

    SbaApplication.all.each do |app|
      app.update_parents!
    end
  end
end
