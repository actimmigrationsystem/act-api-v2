class Enquiry < ApplicationRecord
    has_one_attached :document_upload
    validates :name, :surname, :phonenumber, :email, :gender, :dob, :marital_status,
            :residential_address, :immigration_status, :entry_date,
            :passport_number, :reference_number, :service_type, :elaborate, presence: true
end
