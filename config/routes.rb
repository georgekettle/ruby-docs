Rails.application.routes.draw do
  root "pages#home"
  get "v/:version_id/:klass_name", to: "klasses#show", as: :klass, :version_id => /.*/
end
