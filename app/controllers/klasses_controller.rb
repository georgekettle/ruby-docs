class KlassesController < ApplicationController
  layout "documentation", only: [:show]
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_klass, only: [:edit, :update]

  def show
    @version = Version.find_by_number(params[:version_number])
    @klass = Klass.find_by(name: klass_name, version: @version)
    breadcrumb @klass.name, "#"
    breadcrumb "Overview", klass_url(@klass.version.number, @klass.name)
  end

  def edit
  end

  def update
    if @klass.update(klass_params)
      redirect_to klass_url(@klass.version.number, @klass.name), status: :see_other, notice: "Successfully updated #{@klass.name}"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_klass
    @klass = Klass.find(params[:id])
  end

  def klass_name
    params[:klass_name]&.capitalize
  end

  def klass_params
    params.require(:klass).permit(:name, :version_id, :summary, :content)
  end
end
