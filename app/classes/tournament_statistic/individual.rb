class TournamentStatistic::Individual
	attr_reader :hash_match, :hash_wr
	def initialize(event:, saison:, need_variable:)
		@my_event = Event.find(event)
		@my_saison = saison
		get_variable if need_variable
	end

	def get_variable
		@hash_match = per_player_match
		@hash_wr = per_player_win_rate
	end

	def get_players
		players
	end

	def get_nb_players
		players.length
	end

	def get_matches
		matches
	end

	def get_nb_matches
		matches.length
	end

	private

	attr_reader :my_event, :my_saison

	def players
		array_player = Array.new
  		my_event.matches.each do |matche|
  			unless array_player.include? Player.find(matche.player_1_id)
  				array_player << Player.find(matche.player_1_id)
  			end
  			unless array_player.include? Player.find(matche.player_2_id)
  				array_player << Player.find(matche.player_2_id)
  			end
  		end 
  		array_player
  	end

  	def matches
  		my_event.matches
  	end

  	def per_player_match
  		hash_match_player = Hash.new
  		players.each do |player|
  			result = 0
  			result += Match.where(player_1_id: player.id, event_id: my_event.id).length
  			result += Match.where(player_2_id: player.id, event_id: my_event.id).length
  			hash_match_player[player.id] = result
  		end
  		hash_match_player
  	end

  	def per_player_win_rate
  		hash_wr_player = Hash.new
  		players.each do |player|
  			result = 0.0
  			result += Match.where(player_1_id: player.id, event_id: my_event.id, result: true).length
  			result += Match.where(player_2_id: player.id, event_id: my_event.id, result: false).length
  			hash_wr_player[player.id] = ((result / @hash_match[player.id]) * 100).round
  		end
  		hash_wr_player
  	end
end
