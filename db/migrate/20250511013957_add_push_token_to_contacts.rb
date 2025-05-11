class AddPushTokenToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :push_token, :string
    add_index :contacts, :push_token
    add_column :contacts, :plate_number, :string
    add_index :contacts, :plate_number
  end
end
