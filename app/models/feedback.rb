class Feedback < ApplicationRecord
  belongs_to :target, polymorphic: true
  belongs_to :user, optional: true

  enum score: { negative: 0, positive: 1 }
end
