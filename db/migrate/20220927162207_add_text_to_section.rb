class AddTextToSection < ActiveRecord::Migration[7.0]
  def change
    add_column :sections, :summary, :string
    add_column :sections, :content, :text
  end
end
