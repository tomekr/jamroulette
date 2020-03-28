# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_beta_user

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:display_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:display_name])
  end

  def ensure_beta_user
    unless session[:is_beta_user]
      session[:redirect_to] = request.url
      redirect_to root_path
    end
  end
end
