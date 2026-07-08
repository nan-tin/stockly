class ShoppingItem < ApplicationRecord
  has_one_attached :image
  
  belongs_to :shopping_list
  belongs_to :category

  validates :name, 
            presence: true,
            length: { maximum: 50 }

  validates :quantity,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0,
              less_than_or_equal_to: 100
            }

  validates :memo,
            length: { maximum: 500 }
end
