class Item < ApplicationRecord
  belongs_to :group
  belongs_to :category

  validates :name, 
            presence: true,
            length: { maximum: 50 }

  validates :quantity, 
            presence: true,
            numericality: { 
              only_integer: true,
              greater_than_or_equal_to: 0 
            }

  validates :memo,
            length: { maximum: 500 }
end
