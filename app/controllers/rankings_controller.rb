class RankingsController < ApplicationController
  before_action :get_all_game_statistic, only: [:index]
  before_action :get_game_statistic, only: [:players, :tournois]
  before_action :get_game, only: [:players, :tournois]

  def index
  end

  def players
  end

  def tournois
  end

  private

  def get_game
    @game = params[:game]
  end

  def get_game_statistic
    @game_player_statistic = PlayerStatistic::Game.new(game: params[:game], saison: "1", need_variable: true)
    @game_tournoi_statistic = TournamentStatistic::Game.new(game: params[:game], saison: "1")
  end

  def get_all_game_statistic
    @game_statistic_t7 = PlayerStatistic::Game.new(game: "t7", saison: "1", need_variable: false)
    @game_statistic_doa6 = PlayerStatistic::Game.new(game: "doa6", saison: "1", need_variable: false)
  end

end
