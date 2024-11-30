class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :role, inclusion: { in: %w[client admin] }

  before_validation :set_default_role, on: :create

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  private

  def set_default_role
    self.role ||= "client"
  end
end
