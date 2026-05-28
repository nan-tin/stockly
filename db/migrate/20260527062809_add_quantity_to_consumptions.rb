class AddQuantityToConsumptions < ActiveRecord::Migration[7.1]
  def change
    add_column :consumptions,
               :quantity,
               :integer,
               null: false,
               default: 1,
               comment: "消費数"
  end
end
