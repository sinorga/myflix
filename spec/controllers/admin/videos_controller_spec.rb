require 'spec_helper'

describe Admin::VideosController do
  before { set_user(Fabricate(:admin)) }

  describe "GET new" do
    it "sets @video variable" do
      get :new
      expect(assigns(:video)).to be_a_new(Video)
    end
  end

  describe "POST create" do
    context "with vaild input" do
      before { post :create, video: Fabricate.attributes_for(:video) }
      it "redirects to new video page" do
        expect(response).to redirect_to new_admin_video_path
      end

      it "saves video record" do
        category = Category.last
        expect(category.videos.count).to eq(1)
      end

      it "flashes success message" do
        expect(flash[:success]).not_to be_blank
      end
    end

    context "with invalid input" do
      before { post :create, video: Fabricate.attributes_for(:invalid_video) }
      it "renders to new page" do
        expect(response).to render_template(:new)
      end

      it "sets @video variable" do
        expect(assigns(:video)).to be_kind_of(Video)
      end

      it "does not save video record" do
        category = Category.last
        expect(category.videos.count).to eq(0)
      end

      it "flashes danger message" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end
end
