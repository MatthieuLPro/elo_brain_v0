class ElosController < ApplicationController
	before_action :get_events_for_calculation, only: [:create]
	before_action :get_players_for_calculation, only: [:create]
	before_action :create_initial_elo, only: [:create]

	def index
		@elos = Elo.all
	end

	def new
	end

	def show
	end

	def create
		redirect_to new_elo_path unless @events
		player_array = Array.new
		#update_previous_ranking
		@events.each do |event|
			matches = event.matches.all.sort_by { |matche| [matche.phase, matche.ordre] }
			matches.each do |matche|
				player_1 = @players.select { |player| player if player.id == matche.player_1_id }.first
				player_2 = @players.select { |player| player if player.id == matche.player_2_id }.first
				elo = EloCalculService.new(player_1: player_1, player_2: player_2, result: matche.result)
				player_1.elos.create(value: elo.next_player_1, match_id: matche.id, saison: params[:saison][0])
				player_2.elos.create(value: elo.next_player_2, match_id: matche.id, saison: params[:saison][0])
				player_array << player_1 unless player_array.include? player_1
				player_array << player_2 unless player_array.include? player_2
			end
		end
		player_array.each_with_index do |player, i|
			mtr = MatchTournamentService.new(player: player, saison: params[:saison][0])
			player.update(nb_match_total: mtr.nb_match_total, nb_match_saison: mtr.nb_match_saison, nb_tournoi_total: mtr.nb_tournoi_total, nb_tournoi_saison: mtr.nb_tournoi_saison)
		end
	end

	def update
	end

	private

	def elo_params
	end

	def get_matches
		@matches = Match.all.sort_by { |matche| [matche.phase, matche.ordre] }
	end

	def get_event
		@event = Event.find(params[:event_id][0])
		@matches = @event.matches.all.sort_by { |matche| [matche.phase, matche.ordre] }
	end

	# Get all datas we need for elo calculation
	def get_events_for_calculation
		@events = Array.new
		Event.where("event_game='#{params[:event_game]}' AND saison='#{params[:saison][0]}'").each do |event|
			next unless event.matches.first
			next if Elo.find_by(match_id: event.matches.first.id)
			@events << event
		end
	end

	def get_players_for_calculation
		@players = Array.new
		@events.each do |event|
			event.matches.each do |matche|
				player_1 = Player.find(matche.player_1_id)
				player_2 = Player.find(matche.player_2_id)
				@players << player_1 unless @players.include? player_1
				@players << player_2 unless @players.include? player_2 
			end
		end
	end

	# Update previous ranking value of each players in actual season
	def update_previous_ranking
		hash_players = Hash.new
		Player.where("game='#{params[:event_game]}' AND saison_current='#{params[:saison][0]}'").each do |player|
			hash_players[player.nickname] = player.elos.last.value
		end
		hash_players = hash_players.sort_by { |key,value| value}
		hash_players.each_with_index do |(key,value), i|
			Player.find_by(nickname: key).update(previous_ranking: i + 1)
		end
	end

	def create_initial_elo
		@players.each do |player|
			next if Elo.find_by(player_id: player.id, saison: params[:saison][0])
			Elo.create(value: 1500, player_id: player.id, match_id: 0, saison: params[:saison][0])
		end
	end
end