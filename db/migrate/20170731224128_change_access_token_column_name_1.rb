class ChangeAccessTokenColumnName1 < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :token_timestamp, :token_validation_time
  end
end
