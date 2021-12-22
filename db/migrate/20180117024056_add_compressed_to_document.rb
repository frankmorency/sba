class AddCompressedToDocument < ActiveRecord::Migration
  def change
    change_table(:documents) do |t|
      t.string :compressed_status, default: Document::COMPRESSED_STATUS[:ready]
      t.index [:av_status, :compressed_status]
    end
  end
end
