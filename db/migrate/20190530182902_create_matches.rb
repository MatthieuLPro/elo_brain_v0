class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.references :player_1
      t.references :player_2
      t.references :event
      t.boolean :result
      t.integer :ordre
      t.integer :phase
      t.timestamps
    end
  end
end
