class Inquiry < ApplicationRecord
  include ImageValidatable
  
  belongs_to :user

  has_one_attached :image

  enum inquiry_type: {
    bug: 0,
    feature: 1,
    other: 2
  }

  validates :inquiry_type, presence: true

  validates :email,
            presence: true,
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              allow_blank: true
            }

  validates :content,
            presence: true,
            length: {
              maximum: 2_000,
              allow_blank: true
            }

end