# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  if Rails.env.development?
    require 'sidekiq/web'
    require 'sidekiq_unique_jobs/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  scope module: :web do
    root 'home#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'logout', to: 'auth#logout'

    resources :repositories, only: %i[index show new create] do
      resources :checks, only: %i[show create], module: :repositories
    end
  end

  namespace :api do
    resources :checks, only: [:create]
  end
end
