class SectionsController < ApplicationController
  layout "documentation", only: [:show]

  def show
    @version = Version.find_by_number(params[:version_number])
    @klass = Klass.find_by(name: klass_name, version: @version)
    @section = Section.find_by(name: section_name, klass: @klass)
    breadcrumb @klass.name, "#"
    breadcrumb @section.name, klass_url(@klass.version.number, @klass.name)
  end

  private

  def klass_name
    params[:klass_name]&.capitalize
  end

  def section_name
    params[:section_name]
  end
end
