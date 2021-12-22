if defined?(RSpec)
  Rake::Task["spec"].clear

  RSpec::Core::RakeTask.new(:spec) do |task|
    file_list = FileList['spec/**/*_spec.rb']
    file_list = file_list.exclude("spec/features/**/*_spec.rb")
    file_list = file_list.exclude("spec/lib/tasks/eight_a_rake_spec.rb")
    file_list.exclude("spec/models/zz_permissions_spec.rb")

    task.rspec_opts = %w[--format progress --format RspecJunitFormatter --out /tmp/test-results/rspec.xml]
    #
    # task.rspec_opts = %w[-r yarjuf -f JUnit -o results.xml]
    # task.rspec_opts << %w[-f h -o coverage/specs.html]

    task.pattern = file_list
  end

  RSpec::Core::RakeTask.new(:features) do |task|
    file_list = FileList['spec/features/*_spec.rb']
    file_list.exclude("spec/features/am_i_eligible_spec.rb")

    task.rspec_opts = %w[-r yarjuf -f JUnit -o results.xml]
    task.rspec_opts << %w[-f h -o coverage/specs.html]

    task.pattern = file_list
  end

  namespace :spec do
    desc 'full test suite for coverage'
    RSpec::Core::RakeTask.new(:full) do |task|
      file_list = FileList['spec/**/*_spec.rb']
      file_list = file_list.exclude("spec/features/am_i_eligible_spec.rb")
      task.rspec_opts = %w[--format progress --format RspecJunitFormatter --out /tmp/test-results/rspec.xml]
      task.rspec_opts << %w[-f h -o coverage/specs.html]

      task.pattern = file_list
    end

    desc 'fast unit spec build without permissions'
    RSpec::Core::RakeTask.new(:fast) do |task|
      file_list = FileList['spec/**/*_spec.rb']
      file_list.exclude("spec/models/zz_permissions_spec.rb")
      file_list.exclude( FileList['spec/features/*_spec.rb'] )

      task.rspec_opts = %w[-r yarjuf -f JUnit -o results.xml]
      task.rspec_opts << %w[-f h -o coverage/specs.html]

      task.pattern = file_list
    end

    desc 'Just permissions specs'
    RSpec::Core::RakeTask.new(:permissions) do |task|
      file_list = FileList['spec/models/zz_permissions_spec.rb']

      task.rspec_opts = %w[-r yarjuf -f JUnit -o results.xml]
      task.rspec_opts << %w[-f h -o coverage/specs.html]

      task.pattern = file_list
    end
  end
end
