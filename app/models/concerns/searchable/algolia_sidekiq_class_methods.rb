module Searchable::AlgoliaSidekiqClassMethods  
  extend ActiveSupport::Concern
  
  module ClassMethods
    def trigger_sidekiq_worker(record, remove)
      serialized_record = record.to_global_id.to_s
      AlgoliaUpdateJob.perform_later(serialized_record, record.id, remove)
    end
  end
end