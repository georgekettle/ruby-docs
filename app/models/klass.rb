class Klass < ApplicationRecord
  include AlgoliaSearch
  include Searchable::ForKlass # depends on AlgoliaSearch

  belongs_to :version
  has_many :sections, -> { order(name: :asc) }, dependent: :destroy
  belongs_to :parent, class_name: 'Klass', optional: true
  has_many :children, foreign_key: 'parent_id', class_name: 'Klass', dependent: :destroy

  has_rich_text :content

  validates :name, presence: true
  validates :category, presence: true

  enum category: { class: 0, module: 1 }
end
