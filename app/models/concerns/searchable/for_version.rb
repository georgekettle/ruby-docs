module Searchable::ForVersion
  extend ActiveSupport::Concern
  include Searchable::AlgoliaSidekiqClassMethods
 
  included do
    after_save :trigger_update_associations

    algoliasearch index_name: "docs", enqueue: :trigger_sidekiq_worker do
      attribute :number, :id, :created_at, :class

      attributesForFaceting [:version_number, :class]

      searchableAttributes ['unordered(number)']
    end
  end

  def version_number
    number
  end
  
  def trigger_update_associations
    klasses.each do |klass|
      serialized_record = klass.to_global_id.to_s
      AlgoliaUpdateJob.perform_later(serialized_record, klass.id, false)
    end
    sections.each do |section|
      serialized_record = section.to_global_id.to_s
      AlgoliaUpdateJob.perform_later(serialized_record, section.id, false)
    end
  end

  private

  def algolia_id
    "version_#{id}" # ensure the version, klass & section IDs are not conflicting
  end
end