class KlassesController < ApplicationController
  layout "documentation", only: [:show_redirect]
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_klass, only: [:show, :edit, :update, :destroy]

  def show_redirect
    @version = Version.find_by_number(params[:version_number])
    @klass = Klass.find_by(name: klass_name, version: @version)
    breadcrumb @klass.name, "#"
    breadcrumb "Overview", klass_path(@klass)
  end

  def show
    redirect_to klass_redirect_path(@klass.version.number, @klass.name), status: :see_other # check this status
  end

  def new
    @version = Version.find(params[:version_id])
    @klass = Klass.new
  end

  def create
    @klass = Klass.new(klass_params)
    @version = Version.find(params[:version_id])
    @klass.version = @version
    if @klass.save
      redirect_to klass_path(@klass), status: :see_other, notice: "Successfully created #{@klass.name}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @klass.update(klass_params)
      redirect_to klass_path(@klass), status: :see_other, notice: "Successfully updated #{@klass.name} class"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @klass.destroy
    redirect_to version_path(@klass.version), status: :see_other, notice: "Successfully deleted #{@klass.name} class"
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
