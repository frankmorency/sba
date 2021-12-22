
worker_processes ENV["NUMBER_OF_UNICORN_WORKERS"].to_i

APP_PATH = Dir.pwd

working_directory APP_PATH # available in 0.94.0+


listen "/var/run/unicorn/chronic.sock", :backlog => 64
listen 3000, :tcp_nopush => true

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 120

# feel free to point this anywhere accessible on the filesystem
#

if ENV.key?("AWS_ENVIRONMENT")
  stderr_path "/proc/1/fd/2"
  stdout_path "/proc/1/fd/1"
else
  stderr_path "/var/log/unicorn/stderr.log" #APP_PATH + "/log/unicorn.stderr.log"
  stdout_path "/var/log/unicorn/stdout.log" #APP_PATH + "/log/unicorn.stderr.log"
end

pid "/var/run/unicorn/unicorn.pid"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true


#check_client_connection false

before_fork do |server, worker|
end

after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  addr = "127.0.0.1:#{3000 + worker.nr + 1}"
  server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)
end
