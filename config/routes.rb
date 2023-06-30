# frozen_string_literal: true

Rails.application.routes.draw do
  resources :orders do
    resources :items
  end
  root 'orders#index'
end
