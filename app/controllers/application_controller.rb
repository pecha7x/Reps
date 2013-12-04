class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_time_zone
  #after_filter :store_location
  #
  #private
  #def store_location
  #  session[:return_to] = request.fullpath
  #end
  #
  #def clear_stored_location
  #  session[:return_to] = nil
  #end
  #
  #def redirect_back_or_to(alternate)
  #  redirect_to(session[:return_to] || alternate)
  #  clear_stored_location
  #end

  def set_time_zone
    Time.zone = current_user.time_zone if current_user
  end
  #
  #def after_sign_in_path_for(resource)
  #  monitor_path
  #end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :nickname, :time_zone) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :current_password, :password, :password_confirmation, :nickname, :time_zone) }
  end
  protect_from_forgery with: :exception
end
