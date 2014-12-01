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
      queue_item1 = QueueItem.create(position: 1, user: user)
      queue_item2 = QueueItem.create(position: 2, user: Fabricate(:user))
      queue_item3 = QueueItem.create(position: 3, user: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item3])
    end

  end
end
