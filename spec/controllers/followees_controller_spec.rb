require 'spec_helper'

describe FolloweesController do
  before { set_user }
  describe "GET index" do
    it_behaves_like "require_login" do
      let(:action) { get :index }
    end

    it "set @followees variable" do
      bob = Fabricate(:user)
      alice = Fabricate(:user)
      user.followees << [bob, alice]
      get :index
      expect(assigns(:followees)).to match_array([bob, alice])
    end
  end
end
