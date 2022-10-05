class AddTextToKlass < ActiveRecord::Migration[7.0]
  def change
    add_column :klasses, :summary, :string
    add_column :klasses, :content, :text
  end
end
