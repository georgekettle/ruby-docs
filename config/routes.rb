Rails.application.routes.draw do
  devise_for :users
  root "pages#home"
  get "v/:version_number/:klass_name/:section_name", to: "sections#show_redirect", as: :section_redirect, :version_number => /[^\/]+/
  get "v/:version_number/:klass_name", to: "klasses#show_redirect", as: :klass_redirect, :version_number => /[^\/]+/
  get "v/:version_number", to: "versions#show_redirect", as: :version_redirect, :version_number => /[^\/]+/
  get "search", to: "search#search", as: :search

  resources :versions, only: [:show, :edit, :update] do
    resources :klasses, only: [:new, :create]
  end
  resources :klasses, only: [:show, :edit, :update, :destroy] do
    resources :sections, only: [:new, :create]
  end
  resources :sections, only: [:show, :edit, :update, :destroy]
end
