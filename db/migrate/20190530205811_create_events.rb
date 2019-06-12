class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
    	t.integer :sgtournoi_id
    	t.integer :sgevent_id
    	t.string :tournoi_name
    	t.date :tournoi_date
    	t.string :tournoi_place
      t.integer :nb_participant
      t.integer :nb_match
    	t.string :event_game
      t.string :saison
      t.timestamps
    end
  end
end
