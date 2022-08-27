class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections do |t|
      t.string :name
      t.integer :category
      t.text :explanation
      t.references :klass, null: false, foreign_key: true

      t.timestamps
    end
  end
end
