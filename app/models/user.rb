class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_create :generate_auth_token
  validates :role, inclusion: { in: %w[client admin superadmin] }

  before_validation :set_default_role, on: :create
  has_one :profile, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  private
  def generate_auth_token
    self.auth_token = SecureRandom.hex(20) # Generates a random 20-character token
  end
  def set_default_role
    self.role ||= "client"
  end
end
