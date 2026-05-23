class AddCategoryNameToConsumptions < ActiveRecord::Migration[7.1]
  def change
    add_column :consumptions, 
               :category_name,
               :string,
               null: false,
               comment: "消費時点のカテゴリー名"
               
  end
end
