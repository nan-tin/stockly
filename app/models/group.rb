class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :categories, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :consumptions, dependent: :destroy
  has_one :shopping_list, dependent: :destroy

  validates :invite_code, presence: true, uniqueness: true
end
