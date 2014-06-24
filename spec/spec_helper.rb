require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.tty = true
  config.log_level = :error
  config.formatter = :documentation
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

at_exit { ChefSpec::Coverage.report! }
