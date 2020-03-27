# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static#beta'
  post '/validate_beta_user', to: 'static#validate_beta_user'
  get 'home', to: 'static#index'
  get 'rooms/random_room', to: 'rooms#random_room', as: 'random_room'

  resources :rooms, only: %i[create show] do
    resources :jams, only: :create
  end
end
