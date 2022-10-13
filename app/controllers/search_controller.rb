class SearchController < ApplicationController
  skip_before_action :authenticate_user!, only: [:search]

  def search
    @hits = AlgoliaDocsIndexSearcher.new(params[:query]).call
  end

  private

  def client
    Algolia::Search::Client.create(ENV["ALGOLIA_ID"], ENV["ALGOLIA_ADMIN_API_KEY"])
  end
end
