class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :inquiries, dependent: :destroy

  after_create :create_default_group

  def self.guest
    create!(
      email: "guest_#{SecureRandom.hex(10)}@example.com",
      password: SecureRandom.urlsafe_base64,
      guest_token: SecureRandom.urlsafe_base64(32),
      guest_token_expires_at: 30.days.from_now
    )
  end

  private

  def create_default_group
    ActiveRecord::Base.transaction do
      group = Group.create!(
        invite_code: SecureRandom.hex(4)
      )

      GroupUser.create!(
        user: self,
        group: group,
        display_name: email
      )

      ShoppingList.create!(
        group: group
      )
    end
  end
end
