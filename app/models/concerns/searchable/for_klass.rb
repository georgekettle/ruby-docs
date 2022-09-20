module Searchable::ForKlass
  extend ActiveSupport::Concern
 
  included do
    after_touch :index!
    after_save :trigger_update_associations

    algoliasearch per_environment: true do
      attribute :name, :id, :created_at

      attribute :version do
        { id: version.id, number: version.number }
      end

      searchableAttributes ['unordered(name)', 'unordered(version.number)']
    end
  end

  def trigger_update_associations
    sections.each(&:touch)
  end
end