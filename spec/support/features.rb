RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.extend Features::SubdomainHelpers, type: :feature
end
