class AddApiCredentialsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :encrypted_api_key, :string
    add_column :users, :encrypted_api_key_iv, :string
    add_column :users, :encrypted_secret_key, :string
    add_column :users, :encrypted_secret_key_iv, :string
  end
end
