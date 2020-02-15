Rails.application.routes.draw do
  resources :rooms, only: [:create]
  # This has to be above the route definition for 'rooms/:room_hash' 
  # otherwise 'random_room' will be treated as a hash
  get 'rooms/random_room', to: 'rooms#random_room', as: 'random_room'
  get 'rooms/:room_hash', to: 'rooms#show', as: 'room'
  patch 'rooms/:room_hash', to: 'rooms#update'

  root 'static#index'
end
