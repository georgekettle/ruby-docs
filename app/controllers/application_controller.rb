class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  include Versionable, Authorizable

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
