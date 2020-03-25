# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static#index'

  resources :rooms, only: %i[create show] do
    resources :jams, only: :create
  end
end
