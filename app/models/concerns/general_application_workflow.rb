module GeneralApplicationWorkflow
  include NotificationsHelper

  def assign
  end

  def unassign
  end

  def cancel
  end

  def propose_ineligible
  end

  def propose_eligible
  end

  def return_for_modification
  end

  def determination_made_decline_ineligible
  end

  def determination_made_sba_approved
  end

  def submit_without_certificate(signature=true)
    @sba_application = self
    user = current_user
    unless user
      Rails.logger.warn("No current user set for sba application ##{id}")
      user = organization.default_user
    end
    @signatory, @organization  = user, organization # needed for rendering terms

    if signature || questionnaire.force_signature?
      terms = Signature.new(questionnaire).terms.map {|term| term.process(binding) }
      self.signature = {agreed_terms: terms}
    end

    submit_hook

    self.application_submitted_at = Time.now
    self.sam_snapshot = MvwSamOrganization.return_snapshot(organization)
  end

  def expire_last_certificate!
    return unless most_recent_certificate
    most_recent_certificate.expire! unless most_recent_certificate.expired?
  end

  def submit
      transaction do
      submit_without_certificate

      if certificate
        if respond_to?(:returned_with_letter?) && returned_with_letter?
          current_review.resubmit!
        elsif current_review.try(:reconsideration?)
          current_review.process_for_reconsideration!
        else
          certificate.activate!
        end
      else # the first time
        expire_last_certificate! unless program.try(:name) == "mpp"
        create_certificate!
      end
      save!
    end
    certificate
  end

  def create_certificate!
    transaction do
      @certificate = Certificate.factory(organization: organization, certificate_type: questionnaire.certificate_type, original_certificate_id: original_certificate_id)
      @certificate.save!
      update_attribute(:certificate_id, @certificate.id)
    end
  end

  def return_for_modification!
    raise 'Do not call this - call return_for_modification itself!'
  end

  def return_for_modification(without_cert = false)
    new_version = nil

    SbaApplication.transaction do
      persist_workflow_state('inactive') #otherwise we'll get a duplicate application
      certificate.deactivate! unless without_cert

      attrs = { organization: organization, questionnaire: questionnaire, signature: signature, current_sba_application_id: current_sba_application_id, sam_snapshot: MvwSamOrganization.return_snapshot(organization) }
      unless without_cert
        attrs[:certificate_id] = certificate.id
      end
      attrs[:type] = type
      attrs[:master_application_id] = master_application_id
      attrs[:position] = position
      attrs[:kind] = kind if SbaApplication.column_names.include?('kind')
      new_version = SbaApplication.new(attrs)
      new_version.creator_id = creator_id
      new_version.save # must do this before adding biz partners

      # Copy document associations on application on Return for modification
      documents.each do |doc|
        new_version.documents << doc
      end

      business_partners.each do |bp|
        new_version.business_partners << bp.dup
      end
      new_version.save! # to ensure we have biz partners before adding their answers

      answers.each do |answer|
        new_answer = answer.dup
        new_answer.answered_for = new_version.business_partners.find_by(first_name: answer.answered_for.first_name, last_name: answer.answered_for.last_name) if answer.answered_for
        answer.documents.each do |doc|
          new_answer.documents << doc
        end
        new_version.answers   << new_answer
      end
      new_version.save!  # to add the answers...

      # APP-93
      # If we have a form413 we need to update the blob answer value with the copied buisness ownwer.
      form413s = section_spawners.select{ |s| s.name == "form413" }
      form413s.each do |section|
        question = section.questions.first
        answers = question.answers
        answer = answers.last
        unless answer.nil? # This is for the cases when we upload an 8a certificate so we will not have any answers to this question.
          blob = answer.value["value"]
          blob.each_pair do |key, value|
            first_name, last_name = blob[key]["first_name"], blob[key]["last_name"]
            bp = new_version.business_partners.find { |bp| bp.first_name == first_name && bp.last_name == last_name } if new_version.business_partners
            blob[key]["id"] = bp.id unless bp.nil?
            answer.save!
          end
        end
      end

      # update status of original certificate
      # copy over all dynamic sections
      dynamic_sections.order(created_at: :asc).each do |section|
        new_section = section.dup

        if section.parent
          new_section.parent = new_version.sections.find_by(name: section.parent.name)
          if new_section.parent.nil?
            raise "Return to vendor - copy new section has no parent: #{new_section.inspect} copying from #{section.inspect} with parent #{section. parent.inspect}"
          end
        end

        new_section.answered_for = new_version.business_partners.find_by(first_name: section.answered_for.first_name, last_name: section.answered_for.last_name) if section.answered_for
        new_version.sections << new_section
      end

      new_version.save!  # now with dynamic sections

      data = []
      new_version.business_partners.map do |bp|
        data << { model: bp, value: bp.name, sections: new_version.dynamic_sections.where(answered_for: bp).to_a }
      end

      new_version.reload.section_spawners.each do |spawner|
        dsb = DynamicSectionBuilder.new(spawner, nil, [])
        dsb.data = data

        dsb.delete_rules!
        dsb.create_rules!
      end
      # and updated rules for those sections

      new_version.update_skip_info!
      # and progress updated...

      revisions.update_all(current_sba_application_id: new_version.id)

      sections.each do |section|
        to_be_updated = new_version.sections.find_by(name: section.name)
        to_be_updated.update_attributes(is_completed: section.is_completed, is_applicable: section.is_applicable, sub_sections_completed: section.sub_sections_completed, sub_sections_applicable: section.sub_sections_applicable)
      end
    end

    Resque.enqueue IntegrityCheck::SbaAppConsistency, id, new_version.id

    new_version
  end
end