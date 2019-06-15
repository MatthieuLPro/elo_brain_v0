require 'rails_helper'

describe Match do
  
  let(:event) { FactoryBot.create(:event) }
  let(:player_1) { FactoryBot.create(:player) }
  let(:player_2) { FactoryBot.create(:player) }
  let(:my_match) { FactoryBot.create(:match, event: event, player_1_id: player_1.id, player_2_id: player_2.id) }

  let(:valid_attributes) {
    { player_1_id: player_1.id, player_2_id: player_2.id, event_id: event.id, ordre: "0", phase: "0" }
  }

  let(:unvalid_attributes) {
    { player_1_id: player_1.id, player_2_id: player_2.id, event_id: event.id, ordre: nil, phase: "0" }
  }

  describe "create" do
    it "creates a match with all params" do
      Match.create(valid_attributes)
      expect(Match.all.count).to be(1)
    end 

    it "not creates a match without 1 params" do
      Match.create(unvalid_attributes)
      expect(Match.all.count).to be(0)
    end
  end

  describe "associations" do
    it "has many players" do
      count = 0
      count += 1 if Player.find_by(my_match.player_1_id.to_s)
      count += 1 if Player.find_by(my_match.player_2_id.to_s)
      expect(count).to be(2)
    end

    it "belongs to event" do
      expect(my_match.event).to be(event)
    end
  end
end
