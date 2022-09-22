module Searchable::ForKlass
  extend ActiveSupport::Concern
 
  included do
    after_touch :index!
    after_save :trigger_update_associations

    algoliasearch per_environment: true do
      attribute :name, :id, :created_at
      add_attribute :version_number

      attributesForFaceting [:version_number, :class]

      searchableAttributes ['name', 'unordered(version_number)']
    
      add_index "docs", id: :algolia_id do
        attribute :name, :id, :created_at, :class
        add_attribute :version_number

        attributesForFaceting [:version_number, :class]

        searchableAttributes ['name', 'unordered(version_number)']
      end
    end
  end

  def trigger_update_associations
    sections.each(&:touch)
  end

  private

  def version_number
    version.number
  end

  def algolia_id
    "klass_#{id}" # ensure the version, klass & section IDs are not conflicting
  end
end