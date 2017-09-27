class ChangeGradingSchemeTypeInGradingStandard < ActiveRecord::Migration[5.1]
  def up
    change_column :grading_standards, :grading_scheme, :json
  end

  def down
    change_column :grading_standards, :grading_scheme, :text
  end
end
