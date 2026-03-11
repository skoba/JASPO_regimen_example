# frozen_string_literal: true

class CreateCodeSystems < ActiveRecord::Migration[8.0]
  def change
    create_table :code_systems, id: false do |t|
      t.string :id, primary_key: true, limit: 20
      t.string :name, null: false, limit: 100
      t.string :uri, null: false, limit: 255
      t.string :version, limit: 20

      t.timestamps
    end

    add_index :code_systems, :uri, unique: true
  end
end
