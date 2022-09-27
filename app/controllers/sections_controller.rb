class SectionsController < ApplicationController
  layout "documentation", only: [:show_redirect]
  skip_before_action :authenticate_user!, only: [:show]

  def show_redirect
    @version = Version.find_by_number(params[:version_number])
    @klass = Klass.find_by(name: klass_name, version: @version)
    @section = Section.find_by(name: section_name, klass: @klass)
    breadcrumb @klass.name, "#"
    breadcrumb @section.name, klass_path(@klass)
  end

  def show
    @section = Section.find(params[:id])
    redirect_to section_redirect_path(@section.version.number, @section.klass.name, @section.name), status: :see_other
  end

  private

  def klass_name
    params[:klass_name]&.capitalize
  end

  def section_name
    params[:section_name]
  end
end
