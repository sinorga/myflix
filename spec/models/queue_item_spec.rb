require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_uniqueness_of(:video_id).scoped_to(:user_id)}
  it { should validate_presence_of(:video_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_uniqueness_of(:position).scoped_to(:user_id) }

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq(video.title)
    end
  end

  describe "#rating" do
    it "returns the rating from review if the review is present" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: user, video: video, rating: 4)
      queue_item = Fabricate(:queue_item, user: user, video: video)

      expect(queue_item.rating).to eq(4)
    end
    it "returns nil when the review is not present" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)

      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#category_name" do
    it "returns the category's name of the video" do
      category = Fabricate(:category, name: "TV")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)

      expect(queue_item.category_name).to eq("TV")
    end
  end

  describe "#category" do
    it "returns the category of video" do
      category = Fabricate(:category, name: "TV")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)

      expect(queue_item.category).to eq(category)
    end
  end

  describe "#assign_position" do
    it "been called before validate" do
      queue_item = Fabricate.build(:queue_item)
      expect(queue_item).to receive(:assign_position)
      queue_item.save
    end
    it "sets the greatest position index to queue_item if position is not specified" do
      user = Fabricate(:user)
      Fabricate(:queue_item, user: user, position: 1)
      Fabricate(:queue_item, user: user, position: 2)
      queue_item = Fabricate(:queue_item, user: user)
      expect(queue_item.position).to eq(3)
    end
  end
end
