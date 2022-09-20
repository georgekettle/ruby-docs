module Searchable::ForSection
  extend ActiveSupport::Concern
  
  included do
    after_touch :index!

    algoliasearch per_environment: true do
      attribute :name, :category, :id, :created_at

      attribute :version do
        { id: version.id, number: version.number }
      end

      attribute :klass do
        { id: klass.id, name: klass.name }
      end

      searchableAttributes ['unordered(name)', 'unordered(version.number)', 'unordered(klass.name)']
    end
  end
end