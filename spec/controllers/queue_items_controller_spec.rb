require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "redirects to sign in path for unauthenticate user" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
    it "sets @queue_items of with authenticated user" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: Fabricate(:user))
      queue_item3 = Fabricate(:queue_item, user: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item3])
    end

  end

  describe "POST create" do
    it "redirects to sign in path for unauthenticate user" do
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to sign_in_path
    end

    context "with authenticated user" do
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }

      before do
        session[:user_id] = user.id
        post :create, video_id: video.id
      end

      it "redirects to my_queue page" do
        expect(response).to redirect_to my_queue_path
      end

      it "creates a queue_item" do
        expect(QueueItem.count).to eq(1)
      end

      it "creates a queue_item associated with video" do
        expect(QueueItem.first.video).to eq(video)
      end

      it "creates a queue_item associated with the signed in user" do
        expect(QueueItem.first.user).to eq(user)
      end

    end
  end
end
