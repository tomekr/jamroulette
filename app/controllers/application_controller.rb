# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :ensure_beta_user

  private

  def ensure_beta_user
    unless session[:is_beta_user]
      session[:redirect_to] = request.url
      redirect_to root_path
    end
  end
end
