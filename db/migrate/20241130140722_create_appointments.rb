class CreateAppointments < ActiveRecord::Migration[7.2]
  def change
    create_table :appointments do |t|
      t.string :name
      t.string :surname
      t.string :phonenumber
      t.string :email
      t.string :service_type
      t.string :venue
      t.datetime :appointment_date
      t.string :appointment_type

      t.timestamps
    end
  end
end
