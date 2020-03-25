# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static#index'

  resources :rooms, only: %i[create show update]
end
