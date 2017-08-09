class ChangeTokenValidationTimeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :token_validation_time, :token_expires_at
  end
end
