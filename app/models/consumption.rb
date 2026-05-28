class Consumption < ApplicationRecord
  belongs_to :group
  belongs_to :category, optional: true

  validates :category_name, presence: true
  validates :item_name, presence: true
  validates :consumed_at, presence: true
  validates :quantity,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }
end
