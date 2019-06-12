class PlayersController < ApplicationController
	before_action :get_player, only: [:show]
	before_action :get_players, only: [:index]
	before_action :get_players_for_update, only: [:create]

	def index
		@players = Player.where(game: "t7")
	end

	def new
	end

	def show
	end

	def create
	end

	def update
	end

	private

	def player_params
		params.require(:player).permit(:id, :nickname, :team)
	end

	def get_players
		@array_players = []
		Player.all.each do |player|
			@array_players << player unless player.elos.first.nil?
		end
	end

	def get_player
		@player = Player.find(params[:id])
		@player_statistic = PlayerStatisticService.new(player: @player, saison: @player.saison_current)
	end

	def ranking
		@players_array = @array_players.sort_by { |player| [player.elos.sort.last.value] }
		@players_array.reverse!
	end
end
