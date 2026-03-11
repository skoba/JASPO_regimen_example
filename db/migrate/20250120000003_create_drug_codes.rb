# frozen_string_literal: true

class CreateDrugCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :drug_codes do |t|
      t.references :drug, null: false, foreign_key: true
      t.string :code_system_id, null: false, limit: 20
      t.string :code, null: false, limit: 50
      t.string :display, limit: 200

      t.timestamps
    end

    add_foreign_key :drug_codes, :code_systems, column: :code_system_id, primary_key: :id
    add_index :drug_codes, [:drug_id, :code_system_id, :code], unique: true, name: 'idx_drug_codes_unique'
    add_index :drug_codes, :code_system_id
    add_index :drug_codes, :code
  end
end
