# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :ensure_beta_user

  private

  def ensure_beta_user
    redirect_to root_path unless session[:is_beta_user]
  end
end
