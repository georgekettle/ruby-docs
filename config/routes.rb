Rails.application.routes.draw do
  devise_for :users
  root "pages#home"
  get "v/:version_number/:klass_name/:section_name", to: "sections#show", as: :section, :version_number => /[^\/]+/
  get "v/:version_number/:klass_name", to: "klasses#show", as: :klass, :version_number => /[^\/]+/
  get "v/:version_number", to: "versions#show", as: :version, :version_number => /[^\/]+/
  get "search", to: "search#search", as: :search

  resources :klasses, only: [:edit, :update]
end
