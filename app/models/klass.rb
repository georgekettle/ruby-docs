class Klass < ApplicationRecord
  belongs_to :version
  has_many :sections, -> { order(name: :asc) }, dependent: :destroy

  validates :name, presence: true
end
