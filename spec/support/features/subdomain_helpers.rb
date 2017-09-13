module Features
  module SubdomainHelpers
    def within_account_subdomain
      let(:subdomain_url) { "http://#{@account ? @account.subdomain : account.subdomain }.example.com" }
      before {
        if Capybara.current_driver != :rack_test
          Capybara.app_host = "http://#{@account.subdomain}.example.com"
        else
          Capybara.app_host = "http://#{@account.subdomain}.example.com"
        end
      }

      after { Capybara.app_host = "http://www.example.com" }

      yield
    end
  end
end
