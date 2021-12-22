class CreateDeterminationDocTypes < ActiveRecord::Migration
  def change
    ["Determination Letter", "Analysis Letter (Form 1392)"].each do |doc_name|
      DocumentType.create! name: doc_name
    end
  end
end
