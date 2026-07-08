class Category < ApplicationRecord
  belongs_to :group

  has_many :items, dependent: :destroy
  has_many :shopping_items, dependent: :destroy
  has_many :consumptions, dependent: :nullify

  validates :name, 
            presence: true, 
            length: { maximum: 15 },
            uniqueness: { scope: :group_id }
end
