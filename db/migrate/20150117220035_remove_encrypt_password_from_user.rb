class RemoveEncryptPasswordFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :encrypt_password, :string
  end
end
