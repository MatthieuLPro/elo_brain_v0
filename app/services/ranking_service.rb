class RankingService
	def initialize(saison:)
		@my_saison = saison
	end

	def get_top_10_t7
		top_10("t7")
	end

	def get_top_10_smbu
		top_10("smbu")
	end

	private

	attr_reader :my_saison

	def top_10(game)
		Player.where(game: game, saison_current: my_saison).sort_by { |player| player.elos.last.value }.reverse
	end

end