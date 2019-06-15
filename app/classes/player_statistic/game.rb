class PlayerStatistic::Game
	attr_reader :hash_win_rate
	def initialize(game:, saison:, need_variable:)
		@my_game = game
		@my_saison = saison
		get_variable if need_variable
	end

	def get_variable
		@hash_win_rate = per_player_win_rate
	end

	def get_player_all
		player_all
	end

	def get_player_saison
		player_saison
	end

	def get_player_top_10_all
		player_top_10_all
	end

	def get_player_top_10_saison
		player_top_10_saison
	end

	private

	attr_reader :my_game, :my_saison

	def player_all
		array_player = Player.where(game: my_game).select do |player|
			player unless player.elos.first.nil?
		end
		array_player.sort_by { |player| player.elos.last.value }.reverse
	end

	def player_saison
		array_player = Player.where(game: my_game, saison_current: my_saison).select do |player|
			player unless player.elos.first.nil?
		end
		array_player.sort_by { |player| player.elos.last.value }.reverse
	end

	def player_top_10_all
		my_index = 0
		top_10 = Player.where(game: my_game).sort_by do |player|
			player.elos.last.value
		end
		top_10.reverse
	end

	def player_top_10_saison
		top_10 = Player.where(game: my_game, saison_current: my_saison).sort_by do |player|
			player.elos.last.value
		end
		top_10.reverse
	end

	def per_player_win_rate
	    hash_win_rate = Hash.new
	    winRate = 0.0
	    nb_victory = 0.0
	    player_all.each do |player|
	      player.elos.each_with_index do |elo, i|
	        next if elo.match_id == 0
	        nb_victory += elo.value - player.elos.sort[i - 1].value < 0 ? 0 : 1
	      end
	      winRate = ((nb_victory / (player.elos.count - 1)) * 100).round
	      hash_win_rate[player.id] = winRate
	      nb_victory = 0.0
	      winRate = 0.0
	    end
	    hash_win_rate
	end
end
