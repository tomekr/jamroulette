# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static#beta'
  post '/validate_beta_user', to: 'static#validate_beta_user'
  get 'home', to: 'static#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users do
    # # Default to json format for all notification routes
    defaults format: :json do
      resources :notifications, only: :index do
        put "read", on: :collection
      end
    end
  end

  resources :rooms, only: %i[create show] do
    resources :jams, only: :create
  end
end
