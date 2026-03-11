# frozen_string_literal: true

class CreateRegimens < ActiveRecord::Migration[8.0]
  def change
    create_table :regimens do |t|
      t.references :regimen_template, null: false, foreign_key: true
      t.references :cancer_type, null: false, foreign_key: true
      t.references :reference_edition, null: false, foreign_key: true
      t.string :line_of_therapy, limit: 20
      t.integer :cycle_days
      t.integer :total_cycles
      t.string :evidence_level, limit: 10
      t.string :page_reference, limit: 50

      t.timestamps
    end

    add_index :regimens, [:regimen_template_id, :cancer_type_id, :reference_edition_id, :line_of_therapy],
              unique: true, name: 'idx_regimens_unique'
  end
end
