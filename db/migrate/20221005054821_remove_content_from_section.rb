class RemoveContentFromSection < ActiveRecord::Migration[7.0]
  def change
    remove_column :sections, :content
  end
end
