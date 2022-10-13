module Searchable::ForSection
  extend ActiveSupport::Concern
  include Searchable::AlgoliaSidekiqClassMethods
  
  included do
    algoliasearch index_name: "docs", enqueue: :trigger_sidekiq_worker do
      attribute :name, :category, :id, :created_at, :class
      add_attribute :version_number
      add_attribute :klass_name

      attributesForFaceting [:version_number, :klass_name, :class]

      searchableAttributes ['unordered(name)', 'unordered(version_number)', 'unordered(klass_name)']
    end
  end

  private

  def klass_name
    klass.name
  end

  def version_number
    version.number
  end

  def algolia_id
    "section_#{id}" # ensure the version, klass & section IDs are not conflicting
  end
end