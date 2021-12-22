require_relative '../section/sub_application'

class Section::ContributorSection < Section::SubApplication
  before_create :set_sub_q_status

  def status
    return super unless !sub_questionnaire && name == "disadvantaged_individuals"
    return super unless children.find_by(name: 'vendor_admin')

    vendor_app = children.find_by(name: 'vendor_admin').children.find_by(name: 'contributor_va_eight_a_disadvantaged_individual')
    sub_statuses = [vendor_app.status]

    children.where('name != ?', 'vendor_admin').each do |parent_section|
      parent_section.children.each do |contributor_section|
        sub_statuses << contributor_section.status
      end
    end

    sub_statuses.uniq!

    if sub_statuses.include?(IN_PROGRESS) || sub_statuses.include?(COMPLETE) && (sub_statuses.include?(INVITATION_EXPIRED) || sub_statuses.include?(NOT_STARTED))
      IN_PROGRESS
    elsif sub_statuses.include?(NOT_STARTED)|| sub_statuses.include?(INVITATION_EXPIRED) || !sub_statuses.include?(COMPLETE)
      NOT_STARTED
    elsif sub_statuses.include?(COMPLETE)
      COMPLETE
    end
  end


  def child_with_user_data(user)
    contributor = nil
    self.children.each do |child|
      if child.description == user.email
        contributor = child
      end
    end
    contributor
  end

  def overview_tile_display_title
    case self.name
      when 'eight_a_disadvantaged_individual'
        'Disadvantaged Individual'
      when 'eight_a_business_partner'
        'Non-Disadvantaged Individual'
      when 'disadvantaged_individuals'
        'Disadvantaged Individual'
      when 'eight_a_spouse'
        'Spouse of Disadvantaged Individual'
      when 'vendor_admin'
        'Disadvantaged Individual'
    end
  end

end