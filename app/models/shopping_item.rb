class ShoppingItem < ApplicationRecord
  include ImageValidatable
  
  has_one_attached :image
  
  belongs_to :shopping_list
  belongs_to :category

  validate :image_size

  validates :name, 
            presence: true,
            length: { maximum: 15 }

  validates :quantity,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0,
              less_than_or_equal_to: 100
            }

  validates :memo,
            length: { maximum: 500 }

  private

  def image_size
    return unless image.attached?

    if image.blob.byte_size > 5.megabytes
      errors.add(:image, "は5MB以下にしてください")
    end
  end
end
