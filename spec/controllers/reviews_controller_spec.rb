require 'spec_helper'

describe ReviewsController do
  before { set_user }

  describe "POST create" do
    it_behaves_like "require_login" do
      let(:video) { Fabricate(:video) }
      let(:action) { post :create, video_id: video.id }
    end

    context "with authenticated user" do
      let(:video) { Fabricate(:video) }

      context "with valid input" do
        before do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        end

        it "redirects to video show page" do
          expect(response).to redirect_to video_path(video)
        end

        it "saves review record" do
          expect(Review.count).to eq(1)
        end
      end

      context "with invalid input" do
        before do

        end
        it "does not save any record" do
          post :create, video_id: video.id, review: {rating: 3}
          expect(Review.count).to eq(0)
        end

        it "renders to video :show template" do
          post :create, video_id: video.id, review: {rating: 3}
          expect(response).to render_template 'videos/show'
        end

        it "sets @video variable" do
          post :create, video_id: video.id, review: {rating: 3}
          expect(assigns(:video)).to eq(video)
        end

        it "sets @reviews variable" do
          review = Fabricate(:review, video: video)
          post :create, video_id: video.id, review: {rating: 3}
          expect(assigns(:reviews)).to eq([review])
        end

        it "sets @new_review variable" do
          post :create, video_id: video.id, review: {rating: 3}
          expect(assigns(:new_review)).to be_a_new(Review)
        end
      end
    end
  end
end
