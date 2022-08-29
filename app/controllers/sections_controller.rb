class SectionsController < ApplicationController
  def show
    @version = Version.find_by_number(params[:version_id])
    @klass = Klass.find_by(name: klass_name, version: @version)
    @section = Section.find_by(name: section_name, klass: @klass)
  end

  private

  def klass_name
    params[:klass_name]&.capitalize
  end

  def section_name
    params[:section_name]
  end
end
