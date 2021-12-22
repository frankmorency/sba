class Ckeditor::AttachmentFile < Ckeditor::Asset
  has_attached_file :data,
                    :url => ":style_:filename",
                    :path => ":style_:filename"

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 100.megabytes
  do_not_validate_attachment_file_type :data

  def url_thumb
    @url_thumb ||= Ckeditor::Utils.filethumb(filename)
  end
end
