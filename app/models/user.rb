class User < ApplicationRecord
  # Include default Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :email, uniqueness: true
  validates :role, inclusion: { in: %w[client admin superadmin] }

  # Associations
  has_one :profile, dependent: :destroy
  has_many :enquiries, dependent: :destroy
  has_many :appointments, dependent: :destroy

  # Callbacks
  before_create :ensure_auth_token
  before_validation :set_default_role, on: :create

  private

  # Generate auth_token before creating a user
  def ensure_auth_token
    self.auth_token ||= SecureRandom.hex(20) # Generates a random 20-character token
  end

  # Set the default role for new users
  def set_default_role
    self.role ||= 'client'
  end
end
