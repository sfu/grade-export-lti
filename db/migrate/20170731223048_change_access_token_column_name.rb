class ChangeAccessTokenColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :token_time, :token_timestamp
  end
end
