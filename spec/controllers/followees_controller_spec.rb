require 'spec_helper'

describe FolloweesController do
  before { set_user }
  describe "GET index" do
    it_behaves_like "require_login" do
      let(:action) { get :index }
    end

    it "set @followees variable to the current user's following relationship" do
      bob = Fabricate(:user)
      alice = Fabricate(:user)
      user.followees << [bob, alice]
      get :index
      expect(assigns(:followees)).to match_array([bob, alice])
    end
  end

  describe "DELETE destroy" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    before { user.followees << alice }

    it_behaves_like "require_login" do
      let(:action) { delete :destroy, id: 3 }
    end

    it "redirects to people page" do
      delete :destroy, id: alice.id
      expect(response).to redirect_to people_path
    end

    it "delete the followee record if the current user is the follower" do
      delete :destroy, id: alice.id
      expect(user.followees.count).to eq(0)
    end

    it "does not delete the followee record if the current user is not the follower" do
      delete :destroy, id: bob.id
      expect(user.followees.count).to eq(1)
    end
  end
end
