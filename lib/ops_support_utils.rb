class OpsSupportUtils
  def reset_password(email, password)
    u = User.find_by_email email
    puts u
    u.reset_password(password, password)
  end

  def confirm_user(email)
    u = User.find_by_email email
    puts u
    u.confirmed_at = Time.now
    u.save!
  end
end
