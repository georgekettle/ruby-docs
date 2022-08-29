Rails.application.routes.draw do
  root "pages#home"
  get "v/:version_id/:klass_name", to: "klasses#show", as: :klass, :version_id => /.*/
  get "v/:version_id/:klass_name/:method", to: "sections#show", as: :section, :version_id => /.*/
end
