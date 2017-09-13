# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)

require 'rake'
require 'rspec/rails'
require 'capybara/rails'
require 'email_spec'
require 'rspec/json_expectations'

# RSpec::Rails::ViewRendering::EmptyTemplatePathSetDecorator.class_eval do
#   alias_method :find_all_anywhere, :find_all
# end

Capybara.javascript_driver = :selenium
Capybara.always_include_port = true

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|  
  config.include FactoryGirl::Syntax::Methods
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include ActiveJob::TestHelper
  config.include RSpec::JsonExpectations::Matchers

  config.filter_run_excluding js: true
  config.filter_run_excluding uploads: true
  config.filter_run_excluding multi_session: true

  [:controller, :view, :request].each do |type|
    config.include ::Rails::Controller::Testing::TestProcess, :type => type
    config.include ::Rails::Controller::Testing::TemplateAssertions, :type => type
    config.include ::Rails::Controller::Testing::Integration, :type => type
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    # Starting an Elastic Search test cluster for complete separation from dev indexes - useful but not necessary
    # Elasticsearch::Model.client = Elasticsearch::Client.new(host: "localhost:9209", log: true)
    # Elasticsearch::Extensions::Test::Cluster.start(port: 9209, path_logs: "/usr/local/var/log/elasticsearch/")
  end

  config.after(:suite) do
    # Stopping the Elastic Search test cluster
    # Elasticsearch::Extensions::Test::Cluster.stop(port: 9209, path_logs: "/usr/local/var/log/elasticsearch/") #if Elasticsearch::Extensions::Test::Cluster.running?
  end

  config.before(:each) do |example|
    if Capybara.current_driver != :rack_test
      Capybara.app_host = "http://example.com"
    else
      Capybara.app_host = "http://example.com"
    end

    if example.metadata[:uploads] || example.metadata[:multi_session]
      Capybara.current_driver = Capybara.javascript_driver
    end

    set_selenium_window_size(1250, 800) if Capybara.current_driver == :selenium

    if example.metadata[:js] || example.metadata[:uploads] || example.metadata[:multi_session]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
      if example.metadata[:type].to_s.eql?("feature")
        page.driver.browser.header("User-Agent", "Rails Testing")
      end
    end

    DatabaseCleaner.start
  end

  config.around(:each) do |example|
    DatabaseCleaner.clean
    example.run
  end

  config.after(:each) do |example|
    Capybara.app_host = "http://www.example.com"
  end
end

def set_selenium_window_size(width, height)
  window = Capybara.current_session.driver.browser.manage.window
  window.resize_to(width, height)
end
