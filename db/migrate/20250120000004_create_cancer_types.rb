# frozen_string_literal: true

class CreateCancerTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :cancer_types do |t|
      t.string :name, null: false, limit: 100

      t.timestamps
    end

    add_index :cancer_types, :name
  end
end
