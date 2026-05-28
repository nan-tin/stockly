class ShoppingItem < ApplicationRecord
  belongs_to :shopping_list
  belongs_to :category

  validates :name, 
            presence: true,
            length: { maximum: 50 }

  validates :quantity,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0
            }

  validates :memo,
            length: { maximum: 500 }
end
