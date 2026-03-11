# frozen_string_literal: true

class CreateReferenceSources < ActiveRecord::Migration[8.0]
  def change
    create_table :reference_sources do |t|
      t.string :name, null: false, limit: 200
      t.string :source_type, null: false, limit: 20  # book, guideline, protocol
      t.string :publisher, limit: 100
      t.string :isbn, limit: 20
      t.string :url, limit: 255

      t.timestamps
    end

    add_index :reference_sources, :source_type
  end
end
