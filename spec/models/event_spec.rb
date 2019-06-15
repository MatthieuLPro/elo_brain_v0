require 'rails_helper'

describe Event do
  
  let(:event) { FactoryBot.create(:event) }
  let(:player_1) { FactoryBot.create(:player) }
  let(:player_2) { FactoryBot.create(:player) }
  let(:my_match) { FactoryBot.create(:match, event: event, player_1_id: player_1.id, player_2_id: player_2.id) }

  let(:valid_attributes) {
    { sgtournoi_id: 1, sgevent_id: 1, tournoi_name: "MyString", tournoi_date: Date.today, tournoi_place: "MyString", event_game: "MyString" }
  }

  let(:unvalid_attributes) {
    { sgtournoi_id: 1, sgevent_id: 1, tournoi_name: "MyString", tournoi_date: Date.today, tournoi_place: "MyString", event_game: nil }
  }

  describe "create" do
    it "creates an event with all params" do
      Event.create(valid_attributes)
      expect(Event.all.count).to be(1)
    end 

    it "not creates an event without 1 params" do
      Event.create(unvalid_attributes)
      expect(Event.all.count).to be(0)
    end
  end
end
