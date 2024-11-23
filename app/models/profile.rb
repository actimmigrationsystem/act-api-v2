class Profile < ApplicationRecord
  belongs_to :user
  validates :first_name, :last_name, :phone_number, :email, presence: true
end
