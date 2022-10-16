class AddScrapeUrlToVersion < ActiveRecord::Migration[7.0]
  def change
    add_column :versions, :scrape_url, :string
  end
end
