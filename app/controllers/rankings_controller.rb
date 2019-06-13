class RankingsController < ApplicationController
  before_action :get_players, only: [:index]
  before_action :get_events, only: [:index]
  before_action :get_game_statistic, only: [:players, :tournois]

  def index
    @ranking = RankingService.new(saison: "1")
  end

  def players
  end

  def tournois
  end

  def tournois_t7
    @tournoi_all = Event.where("event_game='t7' AND nb_participant > 0")
    @tournoi_saison = Event.where("event_game='t7' AND saison=1 AND nb_participant > 0")
  end

  private

  def get_game_statistic
    @game_statistic = PlayerStatistic::Game.new(game: params[:game], saison: "1")
  end

  def get_players
  	@players_t7 = Player.where(game: 't7')
    @players_smbu = Array.new    
    Player.where(game: 'smbu').each do |player|
      @players_smbu << player if player.elos.first
    end
  end

  def get_players_game(game)
    @array_players = Array.new
    Player.where(game: game).each do |player|
      @array_players << player unless player.elos.first.nil?
    end
  end

  def get_events
    @events_t7 = Event.where(event_game: 't7').all.sort_by { |event| event.tournoi_date }
    @events_smbu = Event.where(event_game: 'smbu').all.sort_by { |event| event.tournoi_date }
  end

  def get_events_game(game)
    @nb_tournoi = 0
    @hash_match = Hash.new
    @hash_participant = Hash.new

    @events = Event.where(event_game: game).all.sort_by { |event| event.tournoi_date }
    @events.each do |event|
      @hash_match[event.id] = Match.where(event_id: event.id).length
      next if Match.find_by(event_id: event.id).nil?
      @nb_tournoi += 1
    end

    @events.each do |event|
      array_participant = Array.new
      Match.where(event_id: event.id).each do |matche|
        unless array_participant.include? matche.player_1_id
          array_participant << matche.player_1_id
        end
        unless array_participant.include? matche.player_2_id
          array_participant << matche.player_2_id
        end
      end 
      @hash_participant[event.id] = array_participant.length
      array_participant = nil
    end
  end     

  def nb_matches
  	@hash_match_t7 = Hash.new
    @hash_match_smbu = Hash.new
  	@events_t7.each do |event|
  		@hash_match_t7[event.id] = Match.where(event_id: event.id).length
  	end
    @events_smbu.each do |event|
      @hash_match_smbu[event.id] = Match.where(event_id: event.id).length
    end
  end

  def nb_participants
  	result = 0
  	@hash_participant_t7 = Hash.new
    @hash_participant_smbu = Hash.new
  	@events_t7.each do |event|
		  array_participant = Array.new
  		Match.where(event_id: event.id).each do |matche|
  			unless array_participant.include? matche.player_1_id
  				array_participant << matche.player_1_id
  			end
  			unless array_participant.include? matche.player_2_id
  				array_participant << matche.player_2_id
  			end
  		end 
  		@hash_participant_t7[event.id] = array_participant.length
  		array_participant = nil
  	end
    @events_smbu.each do |event|
      array_participant = Array.new
      Match.where(event_id: event.id).each do |matche|
        unless array_participant.include? matche.player_1_id
          array_participant << matche.player_1_id
        end
        unless array_participant.include? matche.player_2_id
          array_participant << matche.player_2_id
        end
      end 
      @hash_participant_smbu[event.id] = array_participant.length
      array_participant = nil
    end
  end

  def ranking
  	@players_array_t7 = @players_t7.sort_by { |player| [player.elos.sort.last.value] }
  	@players_array_t7.reverse!
    @players_array_smbu = @players_smbu.sort_by { |player| [player.elos.sort.last.value] }
    @players_array_smbu.reverse!
  end


  def ranking_game
    @array_players = @array_players.sort_by { |player| [player.elos.sort.last.value] }
    @array_players.reverse!
  end

  def player_info(game)
    @hash_nb_tournoi = Hash.new
    @hash_win_rate = Hash.new
    @array_nb_tournoi = Array.new
    winRate = 0.0
    nb_victory = 0.0
    @array_players.each do |player|
      array_nb_tournoi = []
      player.elos.each_with_index do |elo, i|
        next if elo.match_id == 0
        nb_victory += elo.value - player.elos.sort[i - 1].value < 0 ? 0 : 1
      end

      Event.where(event_game: game).each do |event|
        if Match.find_by(event_id: event.id, player_1_id: player.id) && (!@array_nb_tournoi.include? event.id)
          @array_nb_tournoi << event.id
        end
      end

      @hash_nb_tournoi[player.nickname] = @array_nb_tournoi.count
      @winRate = ((nb_victory / (player.elos.count - 1)) * 100).round
      @hash_win_rate[player.nickname] = @winRate
      nb_victory = 0.0
      winRate = 0.0
      array_nb_tournoi = nil
    end
  end

  def player_tendance
    @hash_players_tendance = Hash.new
    @array_players.each do |player|
      @hash_players_tendance[player.nickname] = player.ranking_previous - (@array_players.index(@player) + 1)
    end
  end

  def nb_tournois
    @nb_tournoi = 0
    array_tournoi = Array.new
    @player.elos.each do |elo|
      unless array_tournoi.include? Match.find(elo.match_id).event_id.to_s
        @nb_tournoi += 1
        array_tournoi << Match.find(elo.match_id).event_id.to_s 
      end
    end
  end
end
