class RenameNameToItemNameInConsumptions < ActiveRecord::Migration[7.1]
  def change
    rename_column :consumptions, :name, :item_name
  end
end
