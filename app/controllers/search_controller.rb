class SearchController < ApplicationController  
  def search
    @hits = AlgoliaDocsIndexSearcher.new(params[:query]).call
  end

  private

  def client
    Algolia::Search::Client.create(ENV["ALGOLIA_ID"], ENV["ALGOLIA_ADMIN_API_KEY"])
  end

  def index
    i = client.init_index('docs')
    i.set_settings({
      attributesForFaceting: [
        'filterOnly(version_number)' # for filtering purposes only
      ]
    })
    return i
  end
end
