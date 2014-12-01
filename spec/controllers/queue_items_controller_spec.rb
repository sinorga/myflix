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
end
