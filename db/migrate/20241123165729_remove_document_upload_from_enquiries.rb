class RemoveDocumentUploadFromEnquiries < ActiveRecord::Migration[7.2]
  def change
    remove_column :enquiries, :document_upload, :string
  end
end
