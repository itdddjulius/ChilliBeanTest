class AssetNotFound < StandardError; end

class ApplicationJob < ActiveJob::Base
  include Shoryuken::Worker

  def log(msg)
    puts msg
    Rails.logger.warn msg
  end

  def log_error(msg)
    puts msg
    Rails.logger.warn msg
    begin
      raise msg
    rescue Exception => e
      Airbrake.notify(e)
      # raise e
    end
  end
end