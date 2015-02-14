require 'spec_helper'

describe Admin::VideosController do
  before { set_user(Fabricate(:admin)) }

  describe "GET new" do
    it "sets @video variable" do
      get :new
      expect(assigns(:video)).to be_a_new(Video)
    end
  end
end
