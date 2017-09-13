module Features
  module SessionHelpers
    def sign_in_as(user)
      visit root_path
    end

    def in_browser(name)
      old_session = Capybara.session_name

      Capybara.session_name = name
      yield

      Capybara.session_name = old_session
    end
  end
end
