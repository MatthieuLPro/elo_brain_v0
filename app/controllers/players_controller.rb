class PlayersController < ApplicationController
	before_action :authenticate, only: [:new, :create, :update]
	before_action :get_player, only: [:show]
	before_action :get_game_statistics, only: [:index]

	def index
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

	def get_game_statistics
		@game_statistic = PlayerStatistic::Game.new(game: params[:game], saison: "1")
	end

	def get_player
		@player = Player.find(params[:id])
		@game = @player.game
		@player_statistic = PlayerStatistic::Individual.new(player: @player, saison: @player.saison_current)
		@platform = ""
		@platform = "PC" if @player_statistic.get_elo_pc.count > 1
		if @player_statistic.get_elo_ps4.count > 1 && @platform == ""
			@platform = "PS4" 
		elsif @player_statistic.get_elo_ps4.count > 1
			@platform = "PC & PS4"
		end
	end
end
