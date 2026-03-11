# frozen_string_literal: true

class CreateScheduleTimings < ActiveRecord::Migration[8.0]
  def change
    create_table :schedule_timings do |t|
      t.references :regimen_drug_schedule, null: false, foreign_key: true
      t.references :timing_code, null: true, foreign_key: true  # null for IV without specific timing
      t.decimal :dose_per_time, precision: 10, scale: 2, null: false
      t.string :dose_unit, null: false, limit: 20  # mg/m2, mg/kg, mg/body
      t.integer :sequence, null: false

      t.timestamps
    end

    add_index :schedule_timings, [:regimen_drug_schedule_id, :sequence], unique: true, name: 'idx_schedule_timings_unique'
  end
end
