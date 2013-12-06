class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_time_zone

  def set_time_zone
    Time.zone = current_user.time_zone if current_user
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :nickname, :time_zone) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :current_password, :password, :password_confirmation, :nickname, :time_zone) }
  end

  protect_from_forgery with: :exception
end
