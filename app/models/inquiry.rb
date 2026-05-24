class Inquiry < ApplicationRecord
  belongs_to :user

  enum inquiry_type: {
    bug: 0,
    feature: 1,
    other: 2
  }

  validates :email, presence: true
  validates :content, presence: true
  validates :inquiry_type, presence: true
end
