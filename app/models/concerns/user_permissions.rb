module UserPermissions
  extend ActiveSupport::Concern

  def cannot?(*args)
    if args.size == 1
      ability.cannot?(args.first, self)
    else
      ability.cannot?(*args)
    end
  end

  def can?(*args)
    if args.all? {|a| a.is_a? Symbol }
      args.each do |a|
        return false unless ability.can?(a, self)
      end

      true
    else
      ability.can?(*args)
    end
  end

  def can_any_role?(*args)
    args.each do |a|
      return true if self.has_role?(a)
    end

    false
  end

  def can_any?(*args)
    args.each do |a|
      return true if ability.can?(a, self)
    end

    false
  end

  def can_review?(certificate)
    case certificate
      when Certificate::Wosb, Certificate::Edwosb
        can? :ensure_wosb_user
      when Certificate::Mpp
        can? :ensure_mpp_user
      when Certificate::EightA
        can? :ensure_8a_user
      else
        false
    end
  end

  def role_to_type_name
    if can? :ensure_wosb_user
      ['wosb', 'edwosb']
    elsif can? :ensure_mpp_user
      'mpp'
    elsif can? :ensure_8a_user
      'eight_a'
    elsif can? :ensure_ops_support
      ['wosb', 'edwosb', 'mpp', 'eight_a']      
    else
      nil
    end
  end

  def can_review_wosb_mpp?
    can?(:ensure_wosb_user, self) || can?(:ensure_mpp_user, self)
  end

  def can_view_app?(certificate)
    can?(:ensure_vendor, self) && certificate.inactive?
  end
end