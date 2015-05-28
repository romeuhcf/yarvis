require 'sidekiq/web'
require 'sidetiq/web'

Rails.application.routes.draw do
  resources :repositories, only: [:index, :show] do
    resources :changesets, only: [:index, :show] do
      resources :build_jobs, only: [:index, :show]
    end
  end
  resources :changesets, only: [:index, :show] do
    resources :build_jobs, only: [:index, :show]
  end
  resources :build_jobs, only: [:index, :show]

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => '/sidekiq'
end
