class Consumption < ApplicationRecord
  belongs_to :group
  belongs_to :category, optional: true

  validates :category_name, presence: true
  validates :name, presence: true
  validates :consumed_on, presence: true
end
