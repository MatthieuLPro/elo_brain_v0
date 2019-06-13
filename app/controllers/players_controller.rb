class PlayersController < ApplicationController
	before_action :get_player, only: [:show]
	before_action :get_game_statistics, only: [:index]
	before_action :get_players_for_update, only: [:create]

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

	def get_players
		@array_players = PlayerStatistic::Game.new(game: params[:game], saison: "1").get_player_all
	end

	def get_game_statistics
		@game_statistic = PlayerStatistic::Game.new(game: params[:game], saison: "1")
	end

	def get_player
		@player = Player.find(params[:id])
		@player_statistic = PlayerStatistic::Individual.new(player: @player, saison: @player.saison_current)
	end

	def ranking
		@players_array = @array_players.sort_by { |player| [player.elos.sort.last.value] }
		@players_array.reverse!
	end
end
