class VersionsController < ApplicationController
  layout "documentation", only: [:show_redirect]
  skip_before_action :authenticate_user!, only: [:show]
  
  def show_redirect
  end

  def show
    @version = Version.find(params[:id])
    redirect_to version_redirect_path(@version.number), status: :see_other
  end

  def edit
    @version = Version.find(params[:id])
  end

  def update
    if @version.update(version_params)
      redirect_to version_path(@version), status: :see_other, notice: "Version successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def version_params
    params.require(:version).permit(:number)
  end
end
