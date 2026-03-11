# frozen_string_literal: true

class CreateReferenceEditions < ActiveRecord::Migration[8.0]
  def change
    create_table :reference_editions do |t|
      t.references :reference_source, null: false, foreign_key: true
      t.string :edition_number, null: false, limit: 20
      t.date :publication_date
      t.date :effective_date
      t.text :notes

      t.timestamps
    end

    add_index :reference_editions, [:reference_source_id, :edition_number], unique: true, name: 'idx_reference_editions_unique'
    add_index :reference_editions, :publication_date
  end
end
