# Added to config/application.rb - config.middleware.use 'RequestLogger'
class RequestLogger
  def initialize app
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new env
    started_on = Time.now
    begin
      status, _, _ = response = @app.call(env)
      log(env, status, started_on, Time.now)
    rescue Exception => exception
      status = determine_status_code_from_exception(exception)
      log(env, status, started_on, Time.now, exception)
      raise exception
    end

    response
  end

  def log(env, status, started_on, ended_on, exception = nil)
    url = env['REQUEST_URI']
    path = env['PATH_INFO']
    user = try_current_user(env)
    time_spent = ended_on - started_on
    user_agent = env['HTTP_USER_AGENT']
    ip = parse_ip(env)
    request_method = env['REQUEST_METHOD']
    http_host = env['HTTP_HOST']

    RequestLog.info(
      status: status,
      url: url,
      path: path,
      user_id: user.try(:id),
      time_spent: time_spent,
      user_agent: user_agent,
      ip: ip,
      request_method: request_method,
      http_host: http_host,
      error_type: exception&.class&.name,
      error_message: exception&.message
    )
  rescue Exception => exception
    Rails.logger.error(exception.message)
  end

  def parse_ip(env)
    # string of comma separated list of ip addresses
    # first one is the outer most address
    # other may be load balancers, routers, etc ...
    # example: '195.168.122.106, 172.31.19.59'
    ips = env['HTTP_X_FORWARDED_FOR']
    return ips.split(',').first if ips
    # fall back
    env['action_dispatch.remote_ip'].calculate_ip
  end

  def determine_status_code_from_exception(exception)
    exception_wrapper = ActionDispatch::ExceptionWrapper.new(nil, exception)
    exception_wrapper.status_code
  rescue
    500
  end

  def try_current_user(env)
    controller = env['action_controller.instance']
    return unless controller.respond_to?(:current_user, true)
    return unless [-1, 0].include?(controller.method(:current_user).arity)
    controller.__send__(:current_user)
  end
end