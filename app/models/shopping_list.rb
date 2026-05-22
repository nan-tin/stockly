class ShoppingList < ApplicationRecord
  belongs_to :group

  has_many :shopping_items, dependent: :destroy
end
