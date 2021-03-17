# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  resources :notifications do
    member do
      post 'fire'
    end
  end
  mount Sidekiq::Web => '/sidekiq'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
