class AddDefaultToGradingScheme < ActiveRecord::Migration[5.1]
  def up
    change_column :grading_standards, :grading_scheme, :json, default: JSON.generate([{name: 'A+', percentage: 95}, {name: 'A', percentage: 90}, {name: 'A-', percentage: 85},{name:'B+', percentage: 80}, {name: 'B', percentage: 75}, {name: 'B-', percentage: 70}, {name:'C+', percentage: 65}, {name: 'C', percentage: 60}, {name: 'C-', percentage: 55}, {name:'D', percentage: 50}, {name:'F', percentage: 0}])
  end

  def down
    change_column :grading_standards, :grading_scheme, :json, default: JSON.generate([])
  end
end
