class Profile < ApplicationRecord
    # Associations
  belongs_to :user

  # Validations
  validates :first_name, :last_name, presence: true
end
