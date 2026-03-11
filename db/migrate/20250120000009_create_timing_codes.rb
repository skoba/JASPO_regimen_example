# frozen_string_literal: true

class CreateTimingCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :timing_codes do |t|
      t.string :code, null: false, limit: 20
      t.string :display, null: false, limit: 50
      t.string :fhir_when_code, limit: 20
      t.integer :sort_order

      t.timestamps
    end

    add_index :timing_codes, :code, unique: true
    add_index :timing_codes, :sort_order
  end
end
