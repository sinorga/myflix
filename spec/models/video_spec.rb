require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order('created_at desc') }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:large_cover) }
  it { should validate_presence_of(:small_cover) }

  describe ".search_by_title" do
    let!(:run_away) { Fabricate(:video, title: "Run Away", created_at: 1.day.ago) }
    let!(:home_run) { Fabricate(:video, title: "Home Run") }
    let!(:sin_city) { Fabricate(:video, title: "Sin City") }

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

  describe "#recent_reviews" do
    let(:video) { Fabricate(:video) }
    it "returns an empty array if there is not any review" do

      expect(video.recent_reviews).to eq([])
    end

    context "when there are less than 10 reviews" do
      let!(:review_a) { Fabricate(:review, video: video, created_at: 2.day.ago) }
      let!(:review_b) { Fabricate(:review, video: video, created_at: 1.day.ago) }
      let!(:review_c) { Fabricate(:review, video: video, created_at: 3.day.ago) }

      it "returns review in the reverse chronical order by created at" do
        expect(video.recent_reviews).to eq([review_b, review_a, review_c])
      end
      it "returns all review" do
        expect(video.recent_reviews.count).to eq(3)
      end
    end

    context "when there are more than 10 reviews" do
      let!(:reviews) { Fabricate.times(10, :review, video: video, created_at: 1.day.ago) }
      let!(:last_review) { Fabricate(:review, video: video) }
      it "return 6 reviews" do
        expect(video.recent_reviews.count).to eq(10)
      end
      it "returns the most recent reviews" do
        expect(video.recent_reviews).to include(last_review)
      end
    end
  end

  describe "#average_rating" do
    let(:video) { Fabricate(:video) }
    it "returns 0 if there is not any review" do
      expect(video.average_rating).to eq(0)
    end

    it "returns the rating of review if there is only one review" do
      review = Fabricate(:review, video:video)
      expect(video.average_rating).to eq(review.rating)
    end

    it "returns the average rating if there are more than one reviews" do
      review_a = Fabricate(:review, video:video)
      review_b = Fabricate(:review, video:video)
      review_c = Fabricate(:review, video:video)
      review_d = Fabricate(:review, video:video)
      review_e = Fabricate(:review, video:video)

      sum = (review_a.rating + review_b.rating + review_c.rating + review_d.rating + review_e.rating).to_f
      expect(video.average_rating).to eq(sum/5)
    end
  end
end
