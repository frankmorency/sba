require 'simplecov'
require 'simplecov-cobertura'
require 'simplecov/parallel'
require 'rspec'
require 'database_cleaner'
require 'chewy/rspec'

SimpleCov::Parallel.activate

SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter,
                        SimpleCov::Formatter::CoberturaFormatter]

SimpleCov.start 'rails' do
  add_filter 'vendor'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end
