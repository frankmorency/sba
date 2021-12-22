# TODO: Remove this file if not used
# worker_processes 4
#
#
# RACK_ENV = :development
# APP_PATH = Dir.pwd
#
# working_directory APP_PATH # available in 0.94.0+
#
#
# listen "/tmp/chronic.sock", :backlog => 64
# listen 3000, :tcp_nopush => true
#
# # nuke workers after 30 seconds instead of 60 seconds (the default)
# timeout 30
#
# # feel free to point this anywhere accessible on the filesystem
# stderr_path APP_PATH + "/log/unicorn.stderr.log"
# stdout_path APP_PATH + "/log/unicorn.stderr.log"
#
# pid APP_PATH + "/tmp/pids/unicorn.pid"
#
#
#
# preload_app true
# GC.respond_to?(:copy_on_write_friendly=) and
#   GC.copy_on_write_friendly = true
#
#
# #check_client_connection false
#
# before_fork do |server, worker|
# end
#
# after_fork do |server, worker|
#   # per-process listener ports for debugging/admin/migrations
#   addr = "127.0.0.1:#{3000 + worker.nr}"
#   server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)
# end
