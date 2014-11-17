require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  context "search video by title" do
    let!(:run_away) { Video.create(title: "Run Away", description: "a great movie", created_at: 1.day.ago) }
    let!(:home_run) { Video.create(title: "Home Run", description: "a baseball movie") }
    let!(:sin_city) { Video.create(title: "Sin City", description: "a good drama") }

    it "returns an empty array if nothing matched" do
      expect(Video.search_by_title("War")).to eq([])
    end

    it "returns an arrry of one video if only one video matched" do
      expect(Video.search_by_title("Sin City")).to eq([sin_city])
    end

    it "returns an arrry of one video for a partial matched" do
      expect(Video.search_by_title("Sin")).to eq([sin_city])
    end

    it "retruns an array of all matched videos ordered by created_at" do
      expect(Video.search_by_title("Run")).to eq([home_run, run_away])
    end

    it "retruns an empty array for a search with an empty string" do
      expect(Video.search_by_title("")).to eq([])
    end
  end
end
