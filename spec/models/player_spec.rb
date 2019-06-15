require 'rails_helper'

describe Player do
  
  let(:event) { FactoryBot.create(:event) }
  let(:player_1) { FactoryBot.create(:player) }
  let(:player_2) { FactoryBot.create(:player) }
  let(:my_match) { FactoryBot.create(:match, event: event, player_1_id: player_1.id, player_2_id: player_2.id) }
  let(:elo) { FactoryBot.create(:elo, player: player_1)}

  describe "create" do
    it "creates a player with nickname params" do
      Player.create(nickname: "MyString")
      expect(Player.all.count).to be(1)
    end 

    it "not creates a player without nickname params" do
      Player.create(nickname: nil)
      expect(Player.all.count).to be(0)
    end
  end

  describe "associations" do
    before(:each) do
      my_match
      event
      elo
    end
    it "has many matches" do
      expect(Match.where(player_1_id: player_1.id).count).to be(1)
    end

    it "has many events" do
      expect(Event.where(Match.find_by(player_1_id: player_1.id).event_id.to_s).count).to be(1)
    end

    it "has many elos" do
      expect(player_1.elos.count).to be(1)
    end
  end
end
