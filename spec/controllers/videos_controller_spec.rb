require 'spec_helper'

describe VideosController do
  before { set_user }

  describe "GET show" do
    it_behaves_like "require_login" do
      let(:video) { Fabricate(:video) }
      let(:action) { get :show, id: video.id }
    end

    it "sets @video for authenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
      expect(assigns(:video)).to be_decorated_with VideoDecorator
    end

    it "sets @reviews for authenticated users" do
      video = Fabricate(:video)
      reviews = Fabricate.times(5, :review, video: video)

      get :show, id: video.id
      expect(assigns(:reviews)).to match_array(reviews)
    end

    it "sets @new_review for authenticated users" do
      video = Fabricate(:video)

      get :show, id: video.id
      expect(assigns(:new_review)).to be_a_new(Review)
    end

  end

  describe "GET search" do
    it_behaves_like "require_login" do
      let(:action) { get :search, search_term: "Run" }
    end

    it "sets @videos of search result for authenticated users" do
      home_run = Fabricate(:video, title: "Home Run")
      get :search, search_term: "Run"
      expect(assigns(:videos)).to eq([home_run])
    end
  end
end
