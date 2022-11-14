class FeedbacksController < ApplicationController
  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.target = @target
    @feedback.user = current_user if user_signed_in?
    @feedback.ip_address = request.ip_address
    respond_to do |format|
      if @feedback.save
        format.turbo_stream
        format.html { redirect_to @target, status: :see_other, notice: "Thanks for the feedback!" }
      else
        format.html { redirect_to @target, status: :unprocessable_entity, alert: "Something went wrong while saving feedback" }
      end
    end
  end

  private

  def set_target
    debugger
    @target = Section.first
  end

  def feedback_params
    params.require(:feedback).permit(:content, :score)
  end
end
