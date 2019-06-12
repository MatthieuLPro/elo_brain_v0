class EventsController < ApplicationController
	before_action :get_events, only: [:index]
	before_action :get_event, only: [:show]
	before_action :event_modify_params, only: [:create]

	def index
	end

	def new
		@today = Time.now.to_i
	end

	def show
		nb_participant
		nb_match
		nb_match_participant
		victory_rate
		event_matches
		event_podium
	end

	def game
		@game_name = Event.find(params[:event_id]).event_game
    	@events = Event.where(event_game: @game_name).sort_by { |event| event.tournoi_date }
    	@events_season = @events.collect { |event| event.saison == "1" ? event : false }
		@nb_match_total = 0
		@events.each do |event|
			@nb_match_total += event.matches.count
		end
		@nb_match_season = 0
		@events_season.each do |event|
			next unless event
			@nb_match_season += event.matches.count
		end
	end

	def create
		# return root_path unless verify_count
		@tournoi_name.each_with_index do |tournoi, i|
			unless Event.create(sgtournoi_id: @sgtournoi_id[i], 
				sgevent_id: @sgevent_id[i], 
				tournoi_name: @tournoi_name[i],
				tournoi_date: DateTime.strptime(@tournoi_date[i],'%s'),
				nb_participant: 0,
				nb_match: 0,
				event_game: params[:event_game][0],
				tournoi_place: params[:tournoi_place][0],
				saison: params[:saison][0])
				return root_path
			end
		end
		return events_path  
	end

	def edit
	end

	def update
	end

	private

	def event_params
		params.require(:event).permit(:id, :sgtournoi_id, :sgevent_id, :tournoi_name, :tournoi_date)
	end

	def event_modify_params
		@tournoi_name = params[:tournoi_name][0].split('§')
		@tournoi_name.collect! do |tn_name|
			if tn_name == @tournoi_name.first
				tn_name
			else
				tn_name[1..-1] 
			end
		end
		@tournoi_date = params[:tournoi_date][0].split(',')
		@sgtournoi_id = params[:sgtournoi_id][0].split(',')
		@sgevent_id = params[:sgevent_id][0].split(',')
	end

	def get_events
		@events = Event.all.sort_by { |event| event.tournoi_date }
		@events.reverse!
	end

	def get_event
		@event = Event.find(params[:id])
	end

	def nb_participant
		@array_participant = Array.new
  		Match.where(event_id: @event.id).each do |matche|
  			unless @array_participant.include? Player.find(matche.player_1_id)
  				@array_participant << Player.find(matche.player_1_id)
  			end
  			unless @array_participant.include? Player.find(matche.player_2_id)
  				@array_participant << Player.find(matche.player_2_id)
  			end
  		end 
  		@nb_participant = @array_participant.length
  	end

  	def nb_match
  		@nb_match = Match.where(event_id: @event.id).length
  	end

  	def victory_rate
  		@hash_victory_participant = Hash.new
  		@array_participant.each do |participant|
  			result = 0.0
  			result += Match.where(player_1_id: participant.id, event_id: @event.id, result: true).length
  			result += Match.where(player_2_id: participant.id, event_id: @event.id, result: false).length
  			@hash_victory_participant[participant.id] = ((result / @hash_match_participant[participant.id]) * 100).round
  		end
  	end

  	def nb_match_participant
  		@hash_match_participant = Hash.new
  		@array_participant.each do |participant|
  			result = 0
  			result += Match.where(player_1_id: participant.id, event_id: @event.id).length
  			result += Match.where(player_2_id: participant.id, event_id: @event.id).length
  			@hash_match_participant[participant.id] = result
  		end
  	end

  	def event_matches
  		@event_matches = Match.where(event_id: @event.id).sort_by { |matche| [matche.ordre] }
  	end

	def verify_count
		return false unless @tournoi_name.count == @tournoi_date.count
		return false unless @tournoi_name.count == @sgtournoi_id.count
		return false unless @tournoi_name.count == @sgevent_id.count
		true
	end

	def event_podium
		@hash_podium = Hash.new
		@hash_podium["1"] = (@event_matches.last.result ? @event_matches.last.player_1_id : @event_matches.last.player_2_id)
		@hash_podium["2"] = (@event_matches.last.result ? @event_matches.last.player_2_id : @event_matches.last.player_1_id)
		if @event_matches.reverse[0].ordre > 100 && @event_matches.reverse[1].ordre > 100
			@hash_podium["3"] = (@event_matches.reverse[2].result ? @event_matches.reverse[2].player_2_id : @event_matches.reverse[2].player_1_id)		
		else
			@hash_podium["3"] = (@event_matches.reverse[1].result ? @event_matches.reverse[1].player_2_id : @event_matches.reverse[1].player_1_id)		
		end
	end
end
