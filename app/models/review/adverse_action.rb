class Review::AdverseAction < Review::OutOfCycle
  def has_terminal_8a_cert?
    certificate.in_terminal_state?
  end

  def link_to_blank_submitted_app!
    SbaApplication.transaction do
      self.sba_application = Questionnaire::AdverseActionBlank.find_by(name: 'adverse_action_blank').start_application(organization)
      sba_application.ignore_creator = true
      sba_application.save!
      save!
      sba_application.submit!
      case workflow_state
      when :early_graduated
        certificate.finalize_early_graduation!

      when :voluntary_withdrawn
        certificate.finalize_voluntary_withdrawal!

      when :terminated
        certificate.finalize_termination!

      end
    end
  end
end