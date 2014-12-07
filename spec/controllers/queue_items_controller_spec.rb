require 'spec_helper'

describe QueueItemsController do
  before { sign_in_user }

  describe "GET index" do
    it_behaves_like "require_login" do
      let(:action) { get :index }
    end

    it "sets @queue_items of with authenticated user" do
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: Fabricate(:user))
      queue_item3 = Fabricate(:queue_item, user: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item3])
    end

  end

  describe "POST create" do
    it_behaves_like "require_login" do
      let(:video) { Fabricate(:video) }
      let(:action) { post :create, video_id: video.id }
    end

    context "with authenticated user" do
      let(:video) { Fabricate(:video) }
      before do
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
    it_behaves_like "require_login" do
      let(:queue_item) { Fabricate(:queue_item) }
      let(:action) { delete :destroy, id: queue_item.id }
    end

    context "with authenticated user" do
      let(:queue_item) { Fabricate(:queue_item, user: user, position: 1) }

      it "redirects to my queue page" do
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end
      it "deletes the queue item" do
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end
      it "normalize the remain queue items" do
        queue_item2 = Fabricate(:queue_item, user: user, position: 2)
        queue_item3 = Fabricate(:queue_item, user: user, position: 3)
        delete :destroy, id: queue_item.id

        expect(user.queue_items.map(&:position)).to eq([1, 2])
      end


      it "dose not delete the queue item if the user does not own the queue item" do
        user2 = Fabricate(:user)
        queue_item2 =  Fabricate(:queue_item, user: user2)
        delete :destroy, id: queue_item2.id
        expect(QueueItem.count).to eq(1)
      end
    end
  end

  describe "PUT update" do
    it_behaves_like "require_login" do
      let(:queue_item) { Fabricate(:queue_item) }
      let(:action) { put :update_queue, queue_items: {queue_item.id => {position: 2}} }
    end

    context "with authenticated user" do
      context "with valid input" do
        let(:queue_item1) { Fabricate(:queue_item, user: user) }
        let(:queue_item2) { Fabricate(:queue_item, user: user) }

        it "redirects to my_queue page" do
          put :update_queue, queue_items: {queue_item1.id => {position: 2}}
          expect(response).to redirect_to my_queue_path
        end

        it "reorders the queue_items" do
          put :update_queue, queue_items: {
            queue_item1.id => {position: 4},
            queue_item2.id => {position: 3}
          }

          expect(user.queue_items).to eq([queue_item2, queue_item1])
        end

        it "normalizes the positions" do
          put :update_queue, queue_items: {
            queue_item1.id => {position: 4},
            queue_item2.id => {position: 3}
          }
          expect(user.queue_items.map(&:position)).to eq([1, 2])
        end
      end

      context "whit invalid input" do
        let(:user) { Fabricate(:user) }
        let(:queue_item1) { Fabricate(:queue_item, user: user) }
        let(:queue_item2) { Fabricate(:queue_item, user: user) }

        before do
          session[:user_id] = user.id
        end

        it "sets flash error message" do
          put :update_queue, queue_items: {
            queue_item1.id => {position: "abc"}
          }
          expect(flash[:danger]).to be_present
        end

        it "doesn't change any records if one of queue_item is not exist" do
          put :update_queue, queue_items: {
            queue_item1.id => {position: 4},
            8 => {position: 3}
          }
          expect(queue_item1.reload.position).to eq(1)
        end

        it "doesn't change record if queue_item is not belong to sign in user" do
          queue_item3 = Fabricate(:queue_item, position: 1)
          put :update_queue, queue_items: {
            queue_item3.id => {position: 4}
          }
          expect(queue_item3.reload.position).to eq(1)
        end
      end
    end
  end
end
