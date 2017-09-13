module PasswordHelper
  def valid_password
    Faker::Internet.password + "ValidPa$$w0rd"
  end
end

RSpec.configure do |config|
  config.include PasswordHelper
end