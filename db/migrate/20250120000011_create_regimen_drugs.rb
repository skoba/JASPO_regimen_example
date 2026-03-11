# frozen_string_literal: true

class CreateRegimenDrugs < ActiveRecord::Migration[8.0]
  def change
    create_table :regimen_drugs do |t|
      t.references :regimen, null: false, foreign_key: { to_table: :regimens }
      t.references :drug, null: false, foreign_key: true
      t.string :route, null: false, limit: 10  # IV, PO, SC, etc.
      t.integer :duration_min  # minutes
      t.integer :duration_max  # minutes
      t.integer :sequence_number

      t.timestamps
    end

    add_index :regimen_drugs, [:regimen_id, :sequence_number]
  end
end
