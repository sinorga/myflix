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

    it "delete the followee relationship if the current user is the follower" do
      delete :destroy, id: alice.id
      expect(user.followees.count).to eq(0)
    end

    it "does not delete the user record of followee" do
      delete :destroy, id: alice.id
      expect(User.find_by_id(alice.id)).to eq alice
    end

    it "does not delete the followee relationship if the current user is not the follower" do
      delete :destroy, id: bob.id
      expect(user.followees.count).to eq(1)
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }
    it_behaves_like "require_login" do
      let(:action) { post :create, followee_id: 3 }
    end

    it "redirects to followee's page" do
      post :create, followee_id: alice.id
      expect(response).to redirect_to people_path
    end

    it "creates followee for current user" do
      post :create, followee_id: alice.id
      expect(user.followees.first).to eq(alice)
    end

    it "does not create followee for current user if user already follows the followee" do
      user.followees << alice
      post :create, followee_id: alice.id
      expect(user.followees.count).to eq(1)
    end

    it "dese not allow one to follow themselves" do
      post :create, followee_id: user.id
      expect(user.followees.count).to eq(0)
    end

    it "does not create followee for current user if followee does not exist" do
      post :create, followee_id: 7
      expect(user.followees.count).to eq(0)
    end
  end
end
