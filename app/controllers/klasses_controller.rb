class KlassesController < ApplicationController
  layout "documentation", only: [:show]

  def show
    @version = Version.find_by_number(params[:version_number])
    @klass = Klass.find_by(name: klass_name, version: @version)
    breadcrumb @klass.name, "#"
    breadcrumb "Overview", klass_url(@klass.version.number, @klass.name)
  end

  private

  def klass_name
    params[:klass_name]&.capitalize
  end
end
