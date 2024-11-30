class Appointment < ApplicationRecord
  validates :name, :surname, :phonenumber, :email, :service_type, :venue, :appointment_date, :appointment_type, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
end
