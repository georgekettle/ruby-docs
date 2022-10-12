class AddParentToKlass < ActiveRecord::Migration[7.0]
  def change
    add_reference :klasses, :parent, foreign_key: { to_table: :klasses }
  end
end
