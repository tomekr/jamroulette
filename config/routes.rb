# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static#beta'
  post '/validate_beta_user', to: 'static#validate_beta_user'
  get 'home', to: 'static#index'
  get 'explore', to: 'static#explore'

  devise_for :users

  resources :users do
    # # Default to json format for all notification routes
    defaults format: :json do
      resources :notifications, only: :index do
        put 'read', on: :collection
      end
    end
  end

  resources :rooms, only: %i[create show] do
    resources :jams, only: :create do
      put 'promote', on: :member
    end
    get 'random', on: :collection
  end

  resources :groups do
    resources :group_memberships
    # TODO: Add a destroy action
    resources :invites, only: %i[create]
  end
end
