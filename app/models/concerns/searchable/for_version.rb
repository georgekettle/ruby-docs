module Searchable::ForVersion
  extend ActiveSupport::Concern
 
  included do
    algoliasearch per_environment: true do
      attribute :number, :id, :created_at, :class

      attributesForFaceting [:version_number, :class]

      searchableAttributes ['unordered(number)']
    end

    after_save :trigger_update_associations
  end

  def version_number
    number
  end

  def trigger_update_associations
    self.klasses.each(&:touch)
    self.sections.each(&:touch)
  end
end