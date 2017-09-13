module SessionHelper
  def log_in_user(user)
    # user_session = create(:user_session, user: user)
    # cookies.signed[:user_session_key] = user_session.key
  end
end

RSpec.configure do |config|
  config.include SessionHelper, type: :controller
end
