class Player < ApplicationRecord
	has_many :elos, dependent: :destroy
	validates :nickname, presence: true
end
