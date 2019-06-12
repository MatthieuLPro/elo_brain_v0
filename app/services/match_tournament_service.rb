class MatchTournamentService
	def initialize(player:, saison:)
		@player = player
		@saison = saison
	end

	def get_tournoi_total
		tournoi_total_show
	end

	def get_tournoi_saison
		tournoi_saison_show
	end

	def nb_tournoi_total
		tournoi_total.count
	end

	def nb_tournoi_saison
		tournoi_saison.count
	end

	def nb_match_total
		match_total
	end

	def nb_match_saison
		match_saison
	end

	private

	attr_reader :player, :saison

	def match_total
		player.elos.count - 1
	end

	def match_saison
		match_saison = player.elos.collect { |elo| elo if elo.saison == saison }
		match_saison.count - 1
	end

	def tournoi_total
		tournoi_total = Array.new
		player.elos.each do |elo|
			next if elo.match_id == 0
			tournoi_total << Match.find(elo.match_id).event_id unless tournoi_total.include? Match.find(elo.match_id).event_id
		end
		tournoi_total
	end

	def tournoi_saison
		tournoi_saison = Array.new
		player.elos.each do |elo|
			next if elo.match_id == 0
			matche = Match.find(elo.match_id)
			if Event.find(matche.event_id).saison == saison
				tournoi_saison << Match.find(elo.match_id).event_id unless tournoi_saison.include? Match.find(elo.match_id).event_id
			end
		end
		tournoi_saison
	end

	def tournoi_total_show
		tournoi_total_show = Array.new
		tournoi_total.each do |event_id|
			tournoi_total_show << Event.find(event_id) unless tournoi_total_show.include? Event.find(event_id) 
		end
		tournoi_total_show
	end

	def tournoi_saison_show
		tournoi_saison_show = Array.new
		tournoi_total.each do |event_id|
			next unless Event.find(event_id).saison == saison
			tournoi_saison_show << Event.find(event_id) unless tournoi_saison_show.include? Event.find(event_id) 
		end
		tournoi_saison_show
	end
end