class Match < ApplicationRecord
	belongs_to :event
	validates :player_1_id, :player_2_id, :event_id, :ordre, :phase, presence: true
end
