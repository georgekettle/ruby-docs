class Klass < ApplicationRecord
  include AlgoliaSearch
  include Searchable::ForKlass # depends on AlgoliaSearch

  belongs_to :version
  has_many :sections, -> { order(name: :asc) }, dependent: :destroy

  has_rich_text :content

  validates :name, presence: true
  validates :summary, presence: true, length: { maximum: 140 }
end
