module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| "<li>#{msg}</li>" }.join
    sentence = I18n.t("errors.messages.not_saved",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    "<h5>#{sentence}</h5><ul>#{messages}</ul>"
  end

  # Sets the flash message with :key, using I18n. By default you are able
  # to setup your messages using specific resource scope, and if no one is
  # found we look to default scope.
  # Example (i18n locale file):
  #
  #   en:
  #     devise:
  #       passwords:
  #         #default_scope_messages - only if resource_scope is not found
  #         user:
  #           #resource_scope_messages
  #
  # Please refer to README or en.yml locale file to check what messages are
  # available.
  def set_flash_message!(key, kind, options = {})
    message = find_message(kind, options)
    flash[key] = message if message.present?
  end

  def set_up_contributor_if_needed(resource)
    email = resource.email
    contributor = Contributor.find_by_email(email)
    if (contributor && contributor.expires_at > Time.now && resource.roles.empty?)
      resource.roles_map = { "Legacy" => { "VENDOR" => ["contributor"] } }
      resource.organizations << contributor.sba_application.organization
      resource.save!
      role = Role.find_by(name: "contributor")
      VendorRoleAccessRequest.create!(role_id: role.id, organization: contributor.sba_application.organization, user: resource, status: "accepted", accepted_on: Time.now, roles_map: resource.roles_map)
    end  
  end

end
