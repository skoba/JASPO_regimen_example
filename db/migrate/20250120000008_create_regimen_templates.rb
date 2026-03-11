# frozen_string_literal: true

class CreateRegimenTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :regimen_templates do |t|
      t.string :name, null: false, limit: 100
      t.text :description

      t.timestamps
    end

    add_index :regimen_templates, :name
  end
end
