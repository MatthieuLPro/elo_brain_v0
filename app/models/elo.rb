class Elo < ApplicationRecord
	belongs_to :player
	validates :value, :player_id, :saison, presence: true
end
