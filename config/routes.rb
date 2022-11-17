Rails.application.routes.draw do
  devise_for :users
  root "pages#home"
  get "v/:version_number/:klass_name/:section", to: "sections#show_redirect", as: :section_redirect, :version_number => /\d(\.\d\d*){1,2}/
  get "v/:version_number/:klass_name", to: "klasses#show_redirect", as: :klass_redirect, :version_number => /\d(\.\d\d*){1,2}/
  get "v/:version_number", to: "versions#show_redirect", as: :version_redirect, :version_number => /\d(\.\d\d*){1,2}/

  resources :versions do
    member do
      get :main_classes
      get :all_classes
    end
    resources :klasses, only: [:new, :create]
  end
  resources :klasses, only: [:show, :edit, :update, :destroy] do
    member do
      get :instance_methods
      get :class_methods
    end
    resources :sections, only: [:new, :create]
  end
  resources :sections, only: [:show, :edit, :update, :destroy] do
    resources :feedbacks, only: [:create]
  end
  resources :feedbacks, only: [:update]

  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # error routes to custom error controller
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
