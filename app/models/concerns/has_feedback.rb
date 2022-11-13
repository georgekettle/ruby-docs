module HasFeedback
  extend ActiveSupport::Concern

  included do
    has_many :feedbacks, :as => :feedback
  end
end