class RenameConsumedOnToConsumedAtInConsumptions < ActiveRecord::Migration[7.1]
  def change
    rename_column :consumptions, :consumed_on, :consumed_at
  end
end
