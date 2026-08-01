class Consumption < ApplicationRecord
  include ImageValidatable
  
  belongs_to :group
  belongs_to :category, optional: true

  has_one_attached :image

  validate :image_size

  validates :category_name, 
            presence: true,
            length: { maximum: 15 }

  validates :item_name, 
            presence: true,
            length: { maximum: 15 }

  validates :memo,
            length: { maximum: 500 }

  validates :consumed_at, presence: true
  
  validates :quantity,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  private
  def image_size
    return unless image.attached?

    if image.blob.byte_size > 5.megabytes
      errors.add(:image, "は5MB以下にしてください")
    end
  end          
end

