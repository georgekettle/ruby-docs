class ApplicationController < ActionController::Base
  include Versionable

  before_action :authenticate_user!
end
