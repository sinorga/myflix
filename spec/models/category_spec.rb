require 'spec_helper'

describe Category do
  it { should have_many(:videos) }

  describe "#recent_videos" do
    context "when there are less than 6 video in the category" do
      let!(:tv) { Category.create(name: "tv") }
      let!(:run_away) { Video.create(category: tv, title: "Run Away", description: "a great movie", created_at: 2.day.ago) }
      let!(:home_run) { Video.create(category: tv, title: "Home Run", description: "a baseball movie", created_at: 1.day.ago) }
      let!(:sin_city) { Video.create(category: tv, title: "Sin City", description: "a good drama") }

      it "returns the videos in the reverse chronical order by created at" do
        expect(tv.recent_videos).to eq([sin_city, home_run, run_away])
      end

      it "returns all videos" do
        expect(tv.recent_videos.count).to eq(3)
      end
    end

    context "when there are more than 6 video in the category" do
      let!(:tv) { Category.create(name: "tv") }
      let!(:dummy) do
        6.times { Video.create(category: tv, title: "video", description: "a video") }
      end
      let!(:one_piece) {Video.create(category: tv, title: "One Piece", description: "a great cartoon", created_at: 6.day.ago)}

      it "returns 6 videos" do
        expect(tv.recent_videos.count).to eq(6)
      end

      it "returns most recent 6 videos" do
        expect(tv.recent_videos).not_to include(one_piece)
      end
    end

    context "when there is not any video in the category" do
      let!(:movie) { Category.create(name: "movie") }
      it "returns an empty array" do
        expect(movie.recent_videos).to eq([])
      end
    end

  end
end
