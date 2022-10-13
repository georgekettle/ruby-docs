module Searchable::AlgoliaId 
  extend ActiveSupport::Concern
  
  included do
    def algolia_id
      "#{self.class.model_name.param_key}_#{id}"
    end
  end
end