class Section < ApplicationRecord
  belongs_to :klass

  validates :name, presence: true

  enum category: { instance_method: 0, class_method: 1, included_module: 2, inherits_from_parent: 3 }
end
