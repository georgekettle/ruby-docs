class RemoveExplanationFromSection < ActiveRecord::Migration[7.0]
  def change
    remove_column :sections, :explanation
  end
end
