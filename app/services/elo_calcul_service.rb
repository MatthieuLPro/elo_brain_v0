class EloCalculService
	def initialize(player_1:, player_2:, result:)
		@nb_match_1 = player_1.elos.count
		@nb_match_2 = player_2.elos.count
		@elo_1 = player_1.elos.last.value
		@elo_2 = player_2.elos.last.value
		@result = result
	end

	def next_player_1
		calculation_elo("first")
	end

	def next_player_2
		calculation_elo("second")
	end

	private

	attr_reader :nb_match_1, :nb_match_2, :elo_1, :elo_2, :result

	def calculation_elo(player)
		w_1 = match_result[0]
		w_2 = match_result[1]
		k_1 = constante_k(nb_match_1, elo_1)
		k_2 = constante_k(nb_match_2, elo_2)
		if player == "first"
			elo_1 + k_1 * ( w_1 - proba(player) )
		else
			elo_2 + k_2 * ( w_2 - proba(player))
		end
	end

	def proba(player)
		if player == "first"
			constant = -1 
		else
			constant = 1
		end
		1 / (1 + 10**((constant * (elo_1 - elo_2)) / 400))
	end

	def constante_k(nb_match, elo)
		return 40 if nb_match < 31
		return 20 if elo < 2400
		10
	end

	def match_result
		if result
			[1,0]
		else
			[0,1]
		end
	end

end