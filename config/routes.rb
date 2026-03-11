# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root "regimens#index"

  resources :regimens, only: [:index, :show]
  resources :regimen_templates, only: [:index, :show]
  resources :drugs, only: [:index, :show]
  resources :cancer_types, only: [:index, :show]

  get 'database/schema', to: 'database#schema', as: :database_schema
  get 'database/table/:table_name', to: 'database#table', as: :database_table

  # Future API routes will be defined here
  # namespace :api do
  #   namespace :v1 do
  #     resources :regimens, only: [:index, :show]
  #     resources :drugs, only: [:index, :show]
  #     resources :cancer_types, only: [:index, :show]
  #   end
  # end
end
