module Searchable::ForKlass
  extend ActiveSupport::Concern
  include Searchable::AlgoliaSidekiqClassMethods
  
  included do
    after_save :trigger_update_associations

    algoliasearch index_name: "docs", enqueue: :trigger_sidekiq_worker do
      attribute :name, :id, :created_at, :class
      add_attribute :version_number

      attributesForFaceting [:version_number, :class]

      searchableAttributes ['name', 'unordered(version_number)']
    end
  end

  def trigger_update_associations
    sections.each do |section|
      serialized_record = section.to_global_id.to_s
      AlgoliaUpdateJob.perform_later(serialized_record, section.id, false)
    end
  end

  private

  def version_number
    version.number
  end

  def algolia_id
    "klass_#{id}" # ensure the version, klass & section IDs are not conflicting
  end
end