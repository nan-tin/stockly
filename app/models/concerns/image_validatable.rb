module ImageValidatable
  extend ActiveSupport::Concern

  included do
    validate :validate_image
  end

  private

  def validate_image
    return unless image.attached?

    validate_image_size
    validate_image_content_type
  end

  def validate_image_size
    return if image.blob.byte_size <= 5.megabytes

    errors.add(:image, "は5MB以下にしてください")
  end

  def validate_image_content_type
    allowed_types = %w[
      image/jpeg
      image/png
      image/webp
    ]

    return if allowed_types.include?(image.blob.content_type)

    errors.add(:image, "はJPEG、PNG、WebP形式にしてください")
  end
end