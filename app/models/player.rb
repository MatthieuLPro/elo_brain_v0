class Player < ApplicationRecord
	has_many :elos, dependent: :destroy
	has_many :matches
	has_many :events, through: :matches
	validates :nickname, presence: true
end
