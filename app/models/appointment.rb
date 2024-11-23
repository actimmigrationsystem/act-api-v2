class Appointment < ApplicationRecord
    validates :name, :surname, :phonenumber, :email, :service_type,
            :venue, :appointment_date, :appointment_type, presence: true
end
