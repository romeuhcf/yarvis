require 'sidekiq/web'
require 'sidetiq/web'

Rails.application.routes.draw do
  resources :repositories

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => '/sidekiq'
 end
