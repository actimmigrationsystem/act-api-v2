class User < ApplicationRecord
  # Include default Devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Callbacks
  before_save :ensure_auth_token
  before_validation :set_default_role, on: :create

  # Associations
  has_one :profile, dependent: :destroy
  has_many :enquiries, dependent: :destroy

  # Validations
  validates :role, inclusion: { in: %w[client admin superadmin] }

  private

  # Ensure `auth_token` is generated before saving the user
  def ensure_auth_token
    self.auth_token ||= SecureRandom.hex(20) # Generates a random 20-character token
  end

  # Set the default role for new users
  def set_default_role
    self.role ||= "client"
  end
end
