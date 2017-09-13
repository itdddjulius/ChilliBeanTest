module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

  def wait_for_dom
    uuid = SecureRandom.uuid
    page.find("body")
    page.evaluate_script("setTimeout(function() { $('body').append(\"<div id='temp-#{uuid}'>text</div>\"); }, 0);")
    page.find("#temp-#{uuid}")
    page.find(".jstree-ready")
  end
end

RSpec.configure do |config|
  config.include WaitForAjax, type: :feature
end
