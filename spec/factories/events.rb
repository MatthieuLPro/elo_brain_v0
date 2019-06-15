FactoryBot.define do
  factory :event do
    sgtournoi_id    { 0 }
    sgevent_id  	{ 0 }
    tournoi_name   	{ "Mystring" }
    tournoi_date    { Date.today }
    tournoi_place   { "MyString" }
    nb_participant  { 0 }
    nb_match     	{ 0 }
    event_game     	{ "MyString" }
    saison			{ "MyString" }
  end
end
