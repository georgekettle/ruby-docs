class KlassesController < ApplicationController
  layout "blank", :only => [ :show ]

  def show
    @version = Version.find_by_number(params[:version_id])
    @klass = Klass.find_by(name: klass_name, version: @version)
  end

  private

  def klass_name
    params[:klass_name]&.capitalize
  end
end
