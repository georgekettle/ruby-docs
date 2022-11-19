class FeedbacksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :update]
  skip_after_action :verify_authorized, only: [:create, :update]
  after_action :verify_authorized, only: :index
  skip_after_action :verify_policy_scoped, only: :index
  
  before_action :set_target, only: [:create]

  def index
    @dismissed = params[:dismissed] == 'true'
    @feedbacks = Feedback.includes(target: :klass).where(dismissed: @dismissed)
    authorize Feedback
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.target = @target
    @feedback.user = current_user if user_signed_in?
    @feedback.ip_address = request.remote_ip
    respond_to do |format|
      if @feedback.save
        format.html { redirect_to @target, status: :see_other, notice: "Thanks for the feedback!" }
      else
        format.html { redirect_to @target, status: :unprocessable_entity, alert: "Something went wrong while saving feedback" }
      end
    end
  end

  def update
    @feedback = Feedback.find(params[:id])
    @target = @feedback.target
    respond_to do |format|
      if @feedback.update(feedback_params)
        format.html { redirect_back fallback_location: @target, status: :see_other, notice: "Thanks for the feedback!" }
      else
        format.html { redirect_back fallback_location: @target, status: :unprocessable_entity, alert: "Something went wrong while saving feedback" }
      end
    end
  end

  private

  def set_target
    url_first_section = request.path.split('/').second.singularize
    target_class = url_first_section.camelize.constantize
    @target = target_class.find(params["#{url_first_section}_id"])
  end

  def feedback_params
    params.require(:feedback).permit(:comment, :score, :dismissed)
  end
end
