class AddMainMenuToKlass < ActiveRecord::Migration[7.0]
  def change
    add_column :klasses, :main_menu, :boolean, default: false
  end
end
