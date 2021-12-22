# Use Redis Session if SESSION_REDIS_URL is present. Use Active record otherwise

if(ENV["SESSION_REDIS_URL"])
  Rails.application.config.session_store :redis_session_store, {
    key: 'd6de130487a0bd862b834d03c0211e12', #This is simply the name of the cookie stored in the browser, _not_ a secret
    redis: {
      expire_after: 90.minutes,
      key_prefix: 'sbaapp:session:',
      url: ENV["SESSION_REDIS_URL"],
      secure: %w(development test docker build).exclude?(Rails.env)
    }
  }
else
  Rails.application.config.session_store :active_record_store, {:key => 'd6de130487a0bd862b834d03c0211e12',
                                                                :expire_after => 90.minutes}
end
