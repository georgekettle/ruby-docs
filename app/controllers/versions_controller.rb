class VersionsController < ApplicationController
  layout "documentation", only: [:show_redirect]
  skip_before_action :authenticate_user!, only: [:show]
  
  def show_redirect
  end

  def show
    @version = Version.find(params[:id])
    redirect_to version_redirect_path(@version.number), status: :see_other
  end
end
