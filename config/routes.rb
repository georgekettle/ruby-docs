Rails.application.routes.draw do
  root "pages#home"
  get "v/:version_id/:klass_name/:section_name", to: "sections#show", as: :section, :version_id => /\d\.\d/
  get "v/:version_id/:klass_name", to: "klasses#show", as: :klass, :version_id => /\d\.\d/
end
