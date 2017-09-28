class ChangeGradingSchemeDefault < ActiveRecord::Migration[5.1]
  def up
    change_column :grading_standards, :grading_scheme, :json, default: JSON.generate([])
  end

  def down
    change_column :grading_standards, :grading_scheme, :json, default: '[]'
  end
end
