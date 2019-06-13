class PlayerStatistic::Game
	attr_reader :hash_win_rate
	def initialize(game:, saison:)
		@my_game = game
		@my_saison = saison
		get_variable
	end

	def get_variable
		@hash_win_rate = win_rate_per_player
	end

	def get_player_all
		player_all
	end

	def get_player_saison
		player_saison
	end

	def get_tournoi_all
		tournoi_all
	end

	def get_tournoi_saison
		tournoi_saison
	end

	def get_nb_match_all
		nb_match_all
	end

	def get_nb_match_saison
		nb_match_saison
	end

	private

	attr_reader :my_game, :my_saison

	def tournoi_all
		array_tournoi = Event.where(event_game: my_game).select do |tournoi|
			tournoi unless tournoi.matches.first.nil?
		end
		array_tournoi
	end

	def tournoi_saison
		array_tournoi = Event.where(event_game: my_game, saison: my_saison).select do |tournoi|
			tournoi unless tournoi.matches.first.nil?	
		end
		array_tournoi
	end

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

	def nb_match_all
		nb_match = 0
		array_tournoi = Event.where(event_game: my_game).each do |tournoi|
			next if tournoi.matches.first.nil?
			nb_match += tournoi.matches.all.count
		end
		nb_match
	end

	def nb_match_saison
		nb_match = 0
		array_tournoi = Event.where(event_game: my_game, saison: my_saison).each do |tournoi|
			next if tournoi.matches.first.nil?
			nb_match += tournoi.matches.all.count
		end
		nb_match
	end

	def win_rate_per_player
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