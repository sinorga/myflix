require 'spec_helper'

describe InviteUsersController do
  describe "GET new" do
    before { set_user }
    it_behaves_like 'require_login' do
      let(:action) { get :new }
    end

    it "sets @invite_user variable" do
      get :new
      expect(assigns(:invite_user)).to be_a_new(InviteUser)
    end
  end

  describe "POST create" do
    before do
      set_user
      ActionMailer::Base.deliveries.clear
    end
    
    it_behaves_like 'require_login' do
      let(:action) { post :create }
    end

    context "with valid input" do
      let(:bob) { Fabricate.build(:invite_user) }
      before { post :create, invite_user: {name: bob.name, email: bob.email, message: bob.message} }

      it "redirects to home page" do
        expect(response).to redirect_to home_path
      end

      it "saves invite user record" do
        expect(InviteUser.first).not_to be_nil
      end

      it "associates signed in user with invited user" do
        expect(user.reload.invite_users.last.name).to eq(bob.name)
      end

      context "send invite email" do
        it "sends out email" do
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it "sends to invited user" do
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to eq([bob.email])
        end
        it "has right content" do
          message = ActionMailer::Base.deliveries.last
          expect(message.body).to include(bob.name)
          expect(message.body).to include(bob.message)
          expect(message.body).to include(register_path(invite_token: user.invite_users.last.token))
        end
      end
    end

    context "with invalid input" do
      let(:bob) { Fabricate.build(:invalid_invite_user) }
      before { post :create, invite_user: {name: bob.name, email: bob.email, message: bob.message} }

      it "renders to new page" do
        expect(response).to render_template :new
      end

      it "assigns @invite_user variale" do
        expect(assigns(:invite_user)).to be_kind_of(InviteUser)
      end

      it "flashes error message" do
        expect(flash[:danger]).not_to be_empty
      end

      it "does not save invite user" do
        expect(InviteUser.count).to eq(0)
      end

      it "does not send out email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
