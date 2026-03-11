class AddAbbreviationToDrugs < ActiveRecord::Migration[8.0]
  def change
    add_column :drugs, :abbreviation, :string, limit: 20
    add_index :drugs, :abbreviation
  end
end
