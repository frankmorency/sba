class Ckeditor::Picture < Ckeditor::Asset
  has_attached_file :data,
                    :url  => ":style_:basename.:extension",
                    :path => ":style_:basename.:extension",
                    :styles => { :content => '800>', :thumb => '118x100#' },
                    :s3_protocol => 'https'

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 20.megabytes
  validates_attachment_content_type :data, :content_type => %w(image/jpeg image/jpg image/png application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)

  def url_content
    url(:content)
  end
end
