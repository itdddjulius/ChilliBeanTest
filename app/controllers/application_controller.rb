class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception unless Rails.env.test?

  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::RoutingError do |e| not_found(e) end
    rescue_from ActionController::UnknownController do |e| not_found(e) end
    rescue_from ActionController::UnknownFormat do |e| unknown_format(e) end
    rescue_from ActiveRecord::RecordNotFound do |e| not_found(e) end
    rescue_from ActionController::InvalidAuthenticityToken do |e| server_error(e) end
    rescue_from ActionView::MissingTemplate do |e| not_found(e) end
    rescue_from ActionController::BadRequest do |e| server_error(e) end
    rescue_from ActionController::InvalidCrossOriginRequest do |e| server_error(e) end
  end

  helper_method :user_signed_in?
  def user_signed_in?
    cookies.signed[:user_session_key].present?
  end

  helper_method :current_user
  def current_user
    User.first
  end

  helper_method :current_library
  def current_library
    if params[:library_id]
      @current_library ||= Library.find(params[:library_id])
    elsif params[:id] && controller_name.eql?("libraries")
      @current_library ||= Library.find(params[:id])
    end
  end

  def browser_detect
    @user_agent = UserAgent.parse(request.user_agent)
    cookies[:asset_view] = "list" if @user_agent.mobile?

    if browser.ie?(6) || browser.ie?(7) || /iOS 3/ =~ @user_agent.os
      render file: 'public/unsupported_browser', layout: false
    end
  end

  def server_error(e=nil)
    error = e ? e.class : ''
    logger.warn "Encountered Exception #{error} requesting #{request.url} by #{request.remote_ip}. Params: #{params.to_json.to_s}"

    begin
      respond_to do |format|
        format.html { render file: "public/500.html", status: :not_found, layout: false }
        format.json { render json: { error: "Server Error" }, status: :not_found }
      end
    rescue ActionController::UnknownFormat
      render text: "Server Error", status: 500
      return
    end
  end

  def not_found(e=nil)
    error = e ? e.class : ''
    logger.warn "Encountered Exception #{error} requesting #{request.url} by #{request.remote_ip}. Params: #{params.to_json.to_s}"

    begin
      respond_to do |format|
        format.html { render file: "public/404.html", status: :not_found, layout: false }
        format.json { render json: { error: "Not Found" }, status: :not_found }
      end
    rescue ActionController::UnknownFormat
      render text: "Not Found", status: 404
      return
    end
  end

  def unknown_format(e=nil)
    error = e ? e.class : ''
    logger.warn "Encountered Exception #{error} requesting #{request.url} by #{request.remote_ip}. Params: #{params.to_json.to_s}"

    begin
      respond_to do |format|
        format.html { render file: 'public/400.html', status: :bad_request, layout: false }
        format.json { render json: { error: "Unknown Format" }, status: :bad_request }
      end
    rescue ActionController::UnknownFormat
      render text: "Unknown Format", status: 400
      return
    end
  end
end
