class RemoveContentFromKlass < ActiveRecord::Migration[7.0]
  def change
    remove_column :klasses, :content
  end
end
