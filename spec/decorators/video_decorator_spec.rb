require 'spec_helper'

describe VideoDecorator do
  describe "#show_rating" do
    let(:video) {Fabricate(:video)}
    let(:video_decorator) { VideoDecorator.new(video) }
    it "returns presentation of average rating" do
      reviews = Fabricate.times(5, :review, video: video)
      expect(video_decorator.show_rating).to eq(
        "#{video.average_rating.round(1)}/5.0"
      )
    end
    it "returns N/A when there is not reviews" do
      expect(video_decorator.show_rating).to eq("N/A")
    end
  end
end
