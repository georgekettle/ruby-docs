class Section < ApplicationRecord
  include AlgoliaSearch
  include Searchable::ForSection # depends on AlgoliaSearch
  include HasFeedback
  
  belongs_to :klass
  has_one :version, through: :klass

  has_rich_text :rubydocs_says
  has_rich_text :source_code
  
  validates :name, presence: true, uniqueness: { scope: [:category, :klass_id], message: "should be unique in it's class & category" }
  validates :category, presence: true

  enum category: { instance_method: 0, class_method: 1 }

  def formatted_name
    if instance_method?
      "# #{name}"
    elsif class_method?
      ":: #{name}"
    else
      name
    end
  end

  def category_header
    category.gsub("_", " ").capitalize
  end

  def self.format_method_name(name)
    formatted_dashes = name.gsub('-', '2D')
    CGI.escape(formatted_dashes).split("%").reject(&:empty?).join('-')
  end
end
