Rails.application.routes.draw do
  root "pages#home"
  get "v/:version_number/:klass_name/:section_name", to: "sections#show", as: :section, :version_number => /\d\.\d/
  get "v/:version_number/:klass_name", to: "klasses#show", as: :klass, :version_number => /\d\.\d/
end
