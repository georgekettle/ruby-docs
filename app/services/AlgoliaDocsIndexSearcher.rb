class AlgoliaDocsIndexSearcher
  def initialize(query)
    @query = query
    @version = Current.version
    @algolia_index = set_index
  end

  def call
    results = run_search
    ruby_results(results)
  end

  private

  def ruby_results(results)
    ruby_results = results.map! do |result|
                    id = result[:objectID].gsub(/\D/, '')&.to_i
                    result[:class].constantize.find(id)
                  end
    ruby_results.group_by{|instance| instance.class.to_s}
  end

  def run_search
    results = @algolia_index.search(@query, {
      filters: "version_number:#{@version.number}",
      facets: ['class']
    })
    results[:hits]
  end

  def set_index
    i = algolia_client.init_index("docs_#{Rails.env}")
    i.set_settings({
      attributesForFaceting: [
        'filterOnly(version_number)',
        'class'
      ]
    })
    return i
  end

  def algolia_client
    Algolia::Search::Client.create(ENV["ALGOLIA_ID"], ENV["ALGOLIA_ADMIN_API_KEY"])
  end
end