class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :inquiries, dependent: :destroy

  after_create :create_default_group

  def guest?
    guest_token.present?
  end

  def google_login?
    provider == "google_oauth2" 
  end
  

  def self.guest
    create!(
      email: "guest_#{SecureRandom.hex(10)}@example.com",
      password: SecureRandom.urlsafe_base64,
      guest_token: SecureRandom.urlsafe_base64(32),
      guest_token_expires_at: 30.days.from_now
    )
  end

  def self.from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)

    user ||= find_by(email: auth.info.email)

    unless user
      user = new(
        email: auth.info.email,
        password: Devise.friendly_token[0, 20]
      )
    end

    if user.provider.blank? || user.uid.blank?
      user.provider = auth.provider
      user.uid = auth.uid
    end

    user.save!
    user
  end

  private

  def create_default_group
    ActiveRecord::Base.transaction do
      group = Group.create!(
        invite_code: SecureRandom.hex(4),
        owner: self
      )

      GroupUser.create!(
        user: self,
        group: group,
        display_name: email
      )

      ShoppingList.create!(
        group: group
      )

      Category.create!(
        group: group,
        name: "冷蔵庫"
      )
    end
  end
end
