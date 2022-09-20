class Klass < ApplicationRecord
  include AlgoliaSearch
  include Searchable::ForKlass # depends on AlgoliaSearch

  belongs_to :version
  has_many :sections, -> { order(name: :asc) }, dependent: :destroy

  validates :name, presence: true
end
