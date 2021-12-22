class AddStatusToSectionsFor8a < ActiveRecord::Migration
  def change
    add_column :sections, :status, :string  # used for sub applications to determine if the app has been started, is in progress or has been completed
    add_column :sections, :prescreening, :boolean, default: false   # this will be used for any sub-sections / sub applications that are to be completed BEFORE reaching the master 8a questionnaire
    add_column :sections, :is_last, :boolean, default: false  # used to determine which page to use to submit the application (sub apps submit from review, where others submit from signature)
    add_column :sba_applications, :current_section_id, :integer   # used to track the current section for sub applications so you can quickly get back to that section from the master app

    Section.reset_column_information
    Section.direct_descendants.each { |klass| klass.reset_column_information }
    Section::SubQuestionnaire.reset_column_information
  end
end
