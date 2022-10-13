module Searchable::ForSection
  extend ActiveSupport::Concern
  include Searchable::AlgoliaSidekiqClassMethods
  include Searchable::AlgoliaId
  
  included do
    algoliasearch index_name: "docs_#{Rails.env}", id: :algolia_id, enqueue: :trigger_sidekiq_worker do
      attribute :name, :category, :id, :created_at, :class
      add_attribute :version_number
      add_attribute :klass_name

      attributesForFaceting [:version_number, :klass_name, :class]

      searchableAttributes ['name', 'unordered(version_number)', 'unordered(klass_name)']
    end
  end

  private

  def klass_name
    klass.name
  end

  def version_number
    version.number
  end
end