class Item < ApplicationRecord
  include ImageValidatable
  
  belongs_to :group
  belongs_to :category

  has_one_attached :image

  validate :image_size

  validates :name, 
            presence: true,
            length: { maximum: 15 }

  validates :quantity, 
            presence: true,
            numericality: { 
              only_integer: true,
              greater_than_or_equal_to: 0 
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
