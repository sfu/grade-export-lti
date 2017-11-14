class CreateGradingStandards < ActiveRecord::Migration[5.1]
  def change
    create_table :grading_standards do |t|
      t.string :title
      t.text :grading_scheme
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
