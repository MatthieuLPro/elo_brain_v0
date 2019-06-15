require 'rails_helper'

describe Elo do
  
  let(:event) { FactoryBot.create(:event) }
  let(:player_1) { FactoryBot.create(:player) }
  let(:player_2) { FactoryBot.create(:player) }
  let(:my_match) { FactoryBot.create(:match, event: event, player_1_id: player_1.id, player_2_id: player_2.id) }
  let(:elo) { FactoryBot.create(:elo, player: player_1)}

  let(:valid_attributes) {
    { value: 0, player_id: player_1.id, saison: "MyString" }
  }

  let(:unvalid_attributes) {
    { value: 1, player_id: player_1.id, saison: nil }
  }

  describe "create" do
    it "creates an elo with all params" do
      Elo.create(valid_attributes)
      expect(Elo.all.count).to be(1)
    end 

    it "not creates an elo without 1 params" do
      Elo.create(unvalid_attributes)
      expect(Elo.all.count).to be(0)
    end
  end

  describe "associations" do
    it "belongs to player" do
      expect(elo.player).to be(player_1)
    end
  end
end
