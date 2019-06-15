class Event < ApplicationRecord
	validates :sgtournoi_id, :sgevent_id, :tournoi_name, :tournoi_date, :tournoi_place, :event_game, presence: true
	validates :sgevent_id, uniqueness: true 
end
