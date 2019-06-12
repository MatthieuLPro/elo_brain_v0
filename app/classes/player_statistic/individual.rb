module PlayerStatistic
	class Individual
		def initialize(player:, saison:)
			@my_player = player
			@my_saison = saison
		end

		def get_win_rate_saison
			win_rate_saison
		end

		def get_win_rate_total
			win_rate_total
		end

		def get_rival_saison
			rival_saison
		end

		def get_rival_total
			rival_total
		end

		def get_percent_rival_victory
			percent_rival_victory
		end

		private

		attr_reader :my_player, :my_saison

		def win_rate_saison
			nb_victory = 0.0
			my_player.elos.each_with_index do |elo, i|
				if i > 0 && elo.saison == my_saison
					nb_victory += elo.value - my_player.elos.sort[i - 1].value < 0 ? 0 : 1
				end
			end
			((nb_victory / (@player.elos.count - 1)) * 100).round
		end

		def win_rate_total
			nb_victory = 0.0
			my_player.elos.each_with_index do |elo, i|
				if i > 0
					nb_victory += elo.value - my_player.elos.sort[i - 1].value < 0 ? 0 : 1
				end
			end
			((nb_victory / (@player.elos.count - 1)) * 100).round
		end

		def rival_saison
			hash_rival = Hash.new
			my_player.elos.each do |elo|
				next if elo.match_id == 0
				next if elo.saison == my_saison
				matche = Match.find(elo.match_id)
				if Player.find(matche.player_1_id).nickname == my_player.nickname
					adversaire = Player.find(matche.player_2_id).nickname
				else
					adversaire = Player.find(matche.player_1_id).nickname
				end
				hash_rival[adversaire] = 0 unless hash_rival[adversaire]
				hash_rival[adversaire] += 1 if hash_rival[adversaire]
			end
			hash_rival.sort_by { |key, value| value}.last
		end

		def rival_total
			hash_rival = Hash.new
			my_player.elos.each do |elo|
				next if elo.match_id == 0
				matche = Match.find(elo.match_id)
				if Player.find(matche.player_1_id).nickname == my_player.nickname
					adversaire = Player.find(matche.player_2_id).nickname
				else
					adversaire = Player.find(matche.player_1_id).nickname
				end
				hash_rival[adversaire] = 0 unless hash_rival[adversaire]
				hash_rival[adversaire] += 1 if hash_rival[adversaire]
			end
			hash_rival.sort_by { |key, value| value}.reverse
	 	end

	 	def percent_rival_victory
	 		hash_rival = rival_total
	 		hash_win_rate = Hash.new
	 		hash_rival.each_with_index do |(key, value), i|
	 			break if i > 2
	 			nb_victory = 0.0
	 			adversaire = Player.find_by(nickname: key)
	 			matches = Match.where(player_1_id: my_player.id, player_2_id: adversaire.id) + Match.where(player_1_id: adversaire.id, player_2_id: my_player.id)
	 			matches.each do |matche|
	 				nb_victory += 1.0 if matche.player_1_id == my_player.id && matche.result
	 				nb_victory += 1.0 if matche.player_2_id == my_player.id && !matche.result
	 			end
	 			hash_win_rate[adversaire.nickname] = "#{((nb_victory / matches.count) * 100.0).round}%"
	 		end
	 		hash_win_rate
	 	end
	end
end