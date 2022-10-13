class AlgoliaUpdateJob < ApplicationJob
  queue_as :algolia

  def perform(gloabl_id, id, remove)
    if remove
      # the record has likely already been removed from your database so we cannot
      # use ActiveRecord#find to load it
      index = AlgoliaSearch.client.init_index("docs")
      index.delete_object(id)
    else
      # the record should be present
      record = GlobalID.find(gloabl_id)
      record.index!
    end
  end
end
