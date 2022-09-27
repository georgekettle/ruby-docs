class SectionsController < ApplicationController
  layout "documentation", only: [:show_redirect]
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_section, only: [:show, :edit, :update, :destroy]

  def show_redirect
    @version = Version.find_by_number(params[:version_number])
    @klass = Klass.find_by(name: klass_name, version: @version)
    @section = Section.find_by(name: section_name, klass: @klass)
    breadcrumb @klass.name, "#"
    breadcrumb @section.name, klass_path(@klass)
  end

  def show
    redirect_to section_redirect_path(@section.version.number, @section.klass.name, @section.name), status: :see_other
  end

  def edit
  end

  def update
    if @section.update(section_params)
      redirect_to section_path(@section), status: :see_other, notice: "Section successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @section.destroy
    redirect_to klass_path(@section.klass), status: :see_other, notice: "Successfully deleted section"
  end

  private

  def klass_name
    params[:klass_name]&.capitalize
  end

  def section_name
    params[:section_name]
  end

  def section_params
    params.require(:section).permit(:name, :category, :summary, :content)
  end

  def set_section
    @section = Section.find(params[:id])
  end
end
