# frozen_string_literal: true

Rails.application.routes.draw do
  resources :rooms, only: [:create]
  get 'rooms/:room_hash', to: 'rooms#show', as: 'room'
  root 'static#index'
end
