class TournamentStatistic::Game
	attr_reader :hash_win_rate
	def initialize(game:, saison:)
		@my_game = game
		@my_saison = saison
	end

	def get_tournoi_all
		tournoi_all
	end

	def get_tournoi_saison
		tournoi_saison
	end

	def get_nb_match_all
		nb_match_all
	end

	def get_nb_match_saison
		nb_match_saison
	end

	private

	attr_reader :my_game, :my_saison

	def tournoi_all
		array_tournoi = Event.where(event_game: my_game).select do |tournoi|
			tournoi unless tournoi.matches.first.nil?
		end
		array_tournoi
	end

	def tournoi_saison
		array_tournoi = Event.where(event_game: my_game, saison: my_saison).select do |tournoi|
			tournoi unless tournoi.matches.first.nil?	
		end
		array_tournoi
	end

	def nb_match_all
		nb_match = 0
		array_tournoi = Event.where(event_game: my_game).each do |tournoi|
			next if tournoi.matches.first.nil?
			nb_match += tournoi.matches.all.count
		end
		nb_match
	end

	def nb_match_saison
		nb_match = 0
		array_tournoi = Event.where(event_game: my_game, saison: my_saison).each do |tournoi|
			next if tournoi.matches.first.nil?
			nb_match += tournoi.matches.all.count
		end
		nb_match
	end
	
end
