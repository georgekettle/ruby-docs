class AddCategoryToKlass < ActiveRecord::Migration[7.0]
  def change
    add_column :klasses, :category, :integer, default: 0
  end
end
