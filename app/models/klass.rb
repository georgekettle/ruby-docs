class Klass < ApplicationRecord
  belongs_to :version
  validates :name, presence: true
end
