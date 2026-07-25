class GroupUser < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :display_name, 
            presence: true,
            length: { maximum: 30 }
end
