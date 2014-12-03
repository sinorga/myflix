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

  describe "DELETE destroy" do
    context "with authenticated user" do
      let(:user) { Fabricate(:user) }
      let(:queue_item) { Fabricate(:queue_item, user: user) }
      before do
        session[:user_id] = user.id
      end

      it "redirects to my queue page" do
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end
      it "deletes the queue item" do
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "dose not delete the queue item if the user does not own the queue item" do
        user2 = Fabricate(:user)
        queue_item2 =  Fabricate(:queue_item, user: user2)
        delete :destroy, id: queue_item2.id
        expect(QueueItem.count).to eq(1)
      end
    end
    it "redirects to sign in page for unauthenticate user" do
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to sign_in_path
    end
  end
end
