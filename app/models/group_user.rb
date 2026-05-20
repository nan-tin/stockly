class GroupUser < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :display_name, presence: true
end
