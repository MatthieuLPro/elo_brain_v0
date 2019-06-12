class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :nickname
      t.string :team
      t.string :game
      t.integer :nb_match_total
      t.integer :nb_tournoi_total
      t.integer :nb_match_saison
      t.integer :nb_tournoi_saison
      t.string :place
      t.string :ranking_record
      t.string :ranking_previous
      t.string :saison_current
      t.timestamps
    end
  end
end
