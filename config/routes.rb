Rails.application.routes.draw do
  devise_for :users

  get "admins/sign_in", to: redirect("/users/sign_in")
  get "admins/sign_up", to: redirect("/users/sign_in")

  namespace :admin do
    resources :compensation_reports
    resources :mandates
    resources :newsletter_subscriptions, only: [:index]
    resources :clients do
      resources :roles, only: [:create, :destroy]
      resources :recommendations, only: [:new, :create, :edit, :update, :destroy]
    end
  end

  get  "clients/:slug",          to: "clients#show",         as: :client
  post "clients/:slug/authenticate", to: "clients#authenticate", as: :authenticate_client
  patch "clients/:slug/recommendations/:recommendation_id/status",
        to: "clients#update_recommendation_status", as: :update_client_recommendation_status
  post  "clients/:slug/recommendations/:recommendation_id/request_interview",
        to: "clients#request_interview", as: :request_client_recommendation_interview

  resources :mandates, only: [:index, :show] do
    member do
      post :apply
    end
  end

  resources :contacts, only: [:create]
  resources :talent_pool_applications, only: [:create]
  resources :newsletter_subscriptions, only: [:create] do
    collection do
      get 'confirm/:token', to: 'newsletter_subscriptions#confirm', as: :confirm
    end
  end

  post 'compensation_reports/download', to: 'compensation_reports#download'

  get "home/index"
  get "gdpr", to: "pages#gdpr"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "home#index"
end
