require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "sets @reviews for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      reviews = Fabricate.times(5, :review, video: video)

      get :show, id: video.id
      expect(assigns(:reviews)).to match_array(reviews)
    end

    it "sets @new_review for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)

      get :show, id: video.id
      expect(assigns(:new_review)).to be_a_new(Review)
    end

    it "redirects the unauthenticated user to sign in page" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "GET search" do
    it "sets @videos of search result for authenticated users" do
      home_run = Fabricate(:video, title: "Home Run")
      session[:user_id] = Fabricate(:user).id
      get :search, search_term: "Run"
      expect(assigns(:videos)).to eq([home_run])
    end
    it "redirects the unauthenticated user to sign in page" do
      home_run = Fabricate(:video, title: "Home Run")
      get :search, search_term: "Run"
      expect(response).to redirect_to sign_in_path
    end
  end
end
