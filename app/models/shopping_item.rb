class ShoppingItem < ApplicationRecord
  belongs_to :shopping_list
  belongs_to :category

  validates :name, presence: true

  validates :quantity,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0
            }
end
