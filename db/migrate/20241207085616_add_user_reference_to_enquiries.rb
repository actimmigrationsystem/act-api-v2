class AddUserReferenceToEnquiries < ActiveRecord::Migration[7.0]
  def change
    add_reference :enquiries, :user, null: false, foreign_key: true
  end
end
