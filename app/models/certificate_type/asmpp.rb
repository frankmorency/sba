class CertificateType::ASMPP < CertificateType
  QUESTIONNAIRES = %w(asmpp_initial eight_a_potential_for_success eight_a_control)

  def short_name
    questionnaire('initial').link_label
  end
end
