class ElosController < ApplicationController
	before_action :authenticate, only: [:new, :create, :update]
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
		hash_player_pc = Hash.new
		hash_player_ps4 = Hash.new
		Player.where(game: params[:event_game]).each do |player|
			if player.elos.where(platform: "PC").last
				hash_player_pc[player.id] = player.elos.where(platform: "PC").last.value
			end
			if player.elos.where(platform: "PS4").last
				hash_player_ps4[player.id] = player.elos.where(platform: "PS4").last.value
			end
		end
		hash_player_pc = hash_player_pc.sort_by { |key, value| value }.reverse
		hash_player_ps4 = hash_player_ps4.sort_by { |key, value| value }.reverse
		hash_player_pc.each_with_index do |(key, value), i|
			Player.find(key).update(ranking_previous_pc: i + 1)
		end
		hash_player_ps4.each_with_index do |(key, value), i|
			Player.find(key).update(ranking_previous_ps4: i + 1)
		end
		player_array = Array.new
		@events.reverse.each do |event|
			matches = event.matches.all.sort_by { |matche| [matche.phase, matche.ordre] }
			matches.each do |matche|
				player_1 = @players.select { |player| player if player.id == matche.player_1_id }.first
				player_2 = @players.select { |player| player if player.id == matche.player_2_id }.first
				elo = EloCalculService.new(player_1: player_1, player_2: player_2, result: matche.result, platform: Event.find(matche.event_id).platform)
				player_1.elos.create(value: elo.next_player_1, match_id: matche.id, saison: params[:saison][0], platform: Event.find(matche.event_id).platform)
				player_2.elos.create(value: elo.next_player_2, match_id: matche.id, saison: params[:saison][0], platform: Event.find(matche.event_id).platform)
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

	def create_initial_elo
		@players.each do |player|
			next if Elo.find_by(player_id: player.id, saison: params[:saison][0])
			Elo.create(value: 1500, player_id: player.id, match_id: 0, saison: params[:saison][0], platform: "")
		end
	end
end