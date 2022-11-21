class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.string :ip_address
      t.references :target, polymorphic: true, null: false
      t.references :user, foreign_key: true
      t.integer :score, default: 0
      t.string :comment
      t.boolean :dismissed, default: false

      t.timestamps
    end
  end
end
