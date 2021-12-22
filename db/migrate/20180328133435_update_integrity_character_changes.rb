class UpdateIntegrityCharacterChanges < ActiveRecord::Migration
  def change
    Question.where(name: 'integrity_character_changes').first
            .update_attributes(title: 'In the past program year or since your firm was certified as an 8(a) Participant, has there been conduct by your firm, or any of its principals, indicating a lack of business integrity or good character, which has resulted in any of the following?<br><br>Please check anything not previously reported to SBA:', title_wrapper_tag: nil)
  end
end