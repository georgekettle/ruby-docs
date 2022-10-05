class SectionsController < ApplicationController
  layout "documentation", only: [:show_redirect]
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_section, only: [:show, :edit, :update, :destroy]
  before_action :set_klass, only: [:new, :create]

  def show_redirect
    @version = Version.find_by_number(params[:version_number])
    @klass = Klass.find_by(name: klass_name, version: @version)
    @section = Section.find_by(name: section_name, klass: @klass)
    breadcrumb @klass.name, "#"
    breadcrumb @section.name, klass_path(@klass)
  end

  def show
    flash.keep
    redirect_to section_redirect_path(@section.version.number, @section.klass.name, @section.name), status: :moved_permanently
  end

  def new
    @section = Section.new
  end

  def create
    @section = Section.new(section_params)
    @section.klass = @klass
    if @section.save
      redirect_to section_path(@section), status: :see_other, notice: "Section successfully created"
    else
      render :new, status: :unprocessable_entity
    end
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

  def set_klass
    @klass = Klass.find(params[:klass_id])
  end
end
