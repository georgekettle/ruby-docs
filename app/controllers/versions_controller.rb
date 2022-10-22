class VersionsController < ApplicationController
  layout "documentation", only: [:show_redirect]
  skip_before_action :authenticate_user!, only: [:show, :show_redirect, :main_classes, :all_classes]
  before_action :set_version, only: [:show, :edit, :update, :destroy, :main_classes, :all_classes]
  
  def show_redirect
    @version = Version.find_by_number(params[:version_number])
    authorize @version
  end

  def show
    flash.keep
    redirect_to version_redirect_path(@version.number), status: :moved_permanently
  end

  def new
    @version = Version.new
    authorize @version
  end

  def create
    @version = Version.new(version_params)
    authorize @version
    if @version.save
      redirect_to version_redirect_path(@version.number, format: :html), status: :see_other, notice: "Version successfully created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @version.update(version_params)
      redirect_to version_redirect_path(@version.number, format: :html), status: :see_other, notice: "Version successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @version.destroy
    redirect_to root_path, status: :see_other, notice: "Successfully deleted version"
  end

  def main_classes
    @klasses = @version.main_klasses
  end

  def all_classes
    @klasses = @version.klasses
  end

  private

  def version_params
    params.require(:version).permit(:number)
  end

  def set_version
    @version = Version.find(params[:id])
    authorize @version
  end
end
