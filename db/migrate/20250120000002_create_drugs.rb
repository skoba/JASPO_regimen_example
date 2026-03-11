# frozen_string_literal: true

class CreateDrugs < ActiveRecord::Migration[8.0]
  def change
    create_table :drugs do |t|
      t.string :generic_name, null: false, limit: 200
      t.string :brand_name, limit: 200

      t.timestamps
    end

    add_index :drugs, :generic_name
  end
end
