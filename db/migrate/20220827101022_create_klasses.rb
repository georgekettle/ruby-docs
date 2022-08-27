class CreateKlasses < ActiveRecord::Migration[7.0]
  def change
    create_table :klasses do |t|
      t.string :name
      t.references :version, null: false, foreign_key: true

      t.timestamps
    end
  end
end
