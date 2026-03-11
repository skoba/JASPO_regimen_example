# frozen_string_literal: true

class CreateRegimenDrugSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :regimen_drug_schedules do |t|
      t.references :regimen_drug, null: false, foreign_key: true
      t.integer :start_day, null: false
      t.integer :end_day, null: false
      t.integer :interval_days  # 1=daily, 7=weekly, etc.

      t.timestamps
    end
  end
end
