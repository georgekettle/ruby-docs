class VersionsController < ApplicationController
  layout "documentation", only: [:show]
  skip_before_action :authenticate_user!, only: [:show]
  
  def show
  end
end
