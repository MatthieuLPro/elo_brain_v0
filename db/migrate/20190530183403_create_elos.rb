class CreateElos < ActiveRecord::Migration[5.2]
  def change
    create_table :elos do |t|
      t.float :value
      t.references :player
      t.references :match
      t.string :saison
      t.timestamps
    end
  end
end
