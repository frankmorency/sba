class CertificateType::Mpp < CertificateType
  def short_name
    questionnaire('initial').link_label
  end
end
