class MatchesController < ApplicationController
	before_action :get_matches, only: [:index]
	before_action :get_match, only: [:show]
	before_action :modify_match_params, only: [:create] 

	def index
	end

	def new
		@array_paris_t7 = Array.new
		@array_lyon_t7 = Array.new
		@array_marseille_t7 = Array.new
		@array_paris_smbu = Array.new
		@array_lyon_smbu = Array.new
		@array_marseille_smbu = Array.new
		Event.where(tournoi_place: "paris", event_game: "t7").each do |event|
			@array_paris_t7 << event.sgevent_id
		end
		Event.where(tournoi_place: "lyon", event_game: "t7").each do |event|
			@array_lyon_t7 << event.sgevent_id
		end
		Event.where(tournoi_place: "marseille", event_game: "t7").each do |event|
			@array_marseille_t7 << event.sgevent_id
		end
		Event.where(tournoi_place: "paris", event_game: "smbu").each do |event|
			@array_paris_smbu << event.sgevent_id
		end
		Event.where(tournoi_place: "lyon", event_game: "smbu").each do |event|
			@array_lyon_smbu << event.sgevent_id
		end
		Event.where(tournoi_place: "marseille", event_game: "smbu").each do |event|
			@array_marseille_smbu << event.sgevent_id
		end
	end

	def show
	end

	def create
		array_player = Array.new
		array_match = Array.new
		array_event = Array.new
		modify_result_params
		modify_order_params
		create_player
		@phase.each_with_index do |phase, i|
			next if @result[i].empty?
			next if @result[i][0][2] == "DQ"
			next if @result[i][1][2] == "DQ"
			next if @result[i][0][1].blank?
			next if @result[i][1][1].blank?
			matche = Match.create(phase: phase, ordre: @ordre[i],
				player_1_id: Player.find_by(nickname: @result[i][0][1]).id,
				player_2_id: Player.find_by(nickname: @result[i][1][1]).id,
				result: @result[i][0][2] > @result[i][1][2],
				event_id: Event.find_by(sgevent_id: @event[i]).id)
			array_match << matche
			array_event << matche.event_id unless array_event.include? matche.event_id
		end
		array_event.each do |id|
			array_participant = Array.new
			my_matches = array_match.select { |matche| matche.event_id == id }
			my_matches.each do |matche|
				array_participant << matche.player_1_id unless array_participant.include? matche.player_1_id
				array_participant << matche.player_2_id unless array_participant.include? matche.player_2_id
			end
			Event.find(id).update(nb_match: my_matches.count, nb_participant: array_participant.count)
		end
	end

	def update
	end

	private

	def match_params
		params.require(:match).permit(:id, :event_id, :result, :ordre, :phase)
	end

	def modify_match_params
		@result = params[:result][0].split(',')
		@ordre = params[:ordre][0].split(',')
		@phase = params[:phase][0].split(',')
		@round = params[:round][0].split(',')
		@event = params[:event_id][0].split(',')
	end

	def modify_order_params
		@ordre.collect!.with_index do |ordre, i|
			result = 0
			ordre.each_char.with_index do |char, j|
				if @round[i] == "Grand Final Reset" || @round[i] == "Grand Final"
					result += ((char.ord).to_i - 64) + 100
				else
					result += 24 if j > 0
					result += (char.ord).to_i - 64
				end
			end
			ordre = result
		end
	end

	def modify_result_params
		@result.collect! do |matche|
			matche =  matche.split('-')
			matche.collect! do |matche_sub|
				player_team = ""
				if matche_sub.last == " "
					player_name = matche_sub.first(-3)
				else
					player_name = matche_sub.first(-2)
				end
				if player_name.count('|') == 1
					player_team = player_name.partition('|').first
					player_name = player_name.partition('|').last
				end
				player_team = player_team[0...-1] if player_team.last == " "
				player_team = player_team[1..-1] if player_team.first == " "
				player_name = player_name[0...-1] if player_name.last == " "
				player_name = player_name[1..-1] if player_name.first == " "
				matche_sub = [player_team, player_name, matche_sub.last(2).remove(' ')]
			end
		end
	end

	def get_matches
		@matches = Match.all.sort_by { |matche| [matche.phase, matche.ordre] }
	end

	def get_match
		@match = Match.find(match_params)
	end

	def create_player
		@result.each do |result|
			result.each do |result_sub|
				next if Player.find_by(nickname: result_sub[1])
				player = Player.create(nickname: result_sub[1], team: result_sub[0], 
					game: Event.find_by(sgevent_id: params[:event_id][0]).event_game, 
					nb_match_total: 0, nb_tournoi_total: 0,
					nb_match_saison: 0, nb_tournoi_saison: 0,
					place: params[:place][0],
					ranking_record: 0,
					ranking_previous: 0,
					saison_current: params[:season][0])
			end
		end 
	end

end
