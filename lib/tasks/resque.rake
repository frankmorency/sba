require 'resque/tasks'

task "resque:setup" => :environment

# Start a worker with env vars 
def run_worker(queue)
  env_vars = {"QUEUE" => queue.to_s}
    ## Using Kernel.spawn and Process.detach 
    pid = spawn(env_vars, "rake resque:work")
    Process.detach(pid)
end

# Start a scheduler
def run_scheduler
  puts "Starting resque scheduler"
  env_vars = {
    "BACKGROUND" => "1",
    "PIDFILE" => (Rails.root + "tmp/pids/resque_scheduler.pid").to_s
  }
  pid = spawn(env_vars, "rake resque:scheduler")
  Process.detach(pid)
end

namespace :resque do
  desc "Quit running workers"
  task :stop_workers => :environment do
    pids = Array.new
    Resque.workers.each do |worker|
      pids.concat(worker.worker_pids)
    end
    if pids.empty?
      puts "No workers to kill"
    else
      syscmd = "kill -s QUIT #{pids.join(' ')}"
      puts "Running syscmd: #{syscmd}"
      system(syscmd)
    end
  end
  
  desc "Start workers"
  task :start_workers => :environment do
    run_worker("integrity_check")
  end

  desc "Quit scheduler"
  task :stop_scheduler => :environment do
    pidfile = Rails.root + "tmp/pids/resque_scheduler.pid"
    if !File.exists?(pidfile)
      puts "Scheduler not running"
    else
      pid = File.read(pidfile).to_i
      syscmd = "kill -s QUIT #{pid}"
      puts "Running syscmd: #{syscmd}"
      system(syscmd)
      FileUtils.rm_f(pidfile)
    end
  end

  desc "Start scheduler"
  task :start_scheduler => :environment do
    run_scheduler
  end

end

