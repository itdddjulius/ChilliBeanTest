# Be sure to restart your server when you modify this file.

APP_DOMAIN = Rails.application.config_for(:app_domain)["domain"]

raise "No Domain set in app_domain.yml config. You may need to copy `app_domain.sample.yml` to `app_domain.yml` and fill in the details." unless APP_DOMAIN.present?

Rails.application.config.session_store :cookie_store, key: '_chillipharm_session', domain: APP_DOMAIN, session_secure: true