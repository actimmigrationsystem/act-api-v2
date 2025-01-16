class AddUserReferenceToAppointments < ActiveRecord::Migration[7.2]
  def change
    add_reference :appointments, :user, null: false, foreign_key: true
  end
end
