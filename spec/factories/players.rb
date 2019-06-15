FactoryBot.define do
  factory :player do
    nickname          { "MyString" }
    team              { "MyString" }
    game              { "MyString" }
    nb_tournoi_total  { 0 }
    nb_tournoi_saison { 0 }
    nb_match_total    { 0 }
    nb_match_saison   { 0 }
    place             { "MyString" }
    ranking_record    { 0 }
    ranking_previous  { 0 }
    saison_current    { "MyString" }
  end
end
