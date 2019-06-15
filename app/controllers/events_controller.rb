class EventsController < ApplicationController
	before_action :authenticate, only: [:new, :create, :edit, :update]
	before_action :get_events, only: [:index]
	before_action :get_event, only: [:show]
	before_action :get_event_statistic, only: [:show]
	before_action :event_modify_params, only: [:create]

	def index
	end

	def new
		@today = Time.now.to_i
	end

	def show
	end

	def create
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

	def get_event_statistic
		@tournoi_statistic = TournamentStatistic::Individual.new(event: params[:id], saison: 1, need_variable: true)
	end
end
