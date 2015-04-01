require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it_behaves_like "require_not_login" do
      let(:action) { get :new }
    end

    it "sets @user variable" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it "sets @invite_token variable if token is valid" do
      invite_bob = Fabricate(:invitation)
      get :new, invite_token: invite_bob.token
      expect(assigns(:invite_token)).to eq(invite_bob.token)
    end

    it "redirects to invalid invite token page if token is invialid" do
      alice = Fabricate(:user)
      bob = Fabricate(:invitation, inviter: alice)
      get :new, invite_token: "XXXXXXXX"
      expect(response).to redirect_to invalid_token_path
    end
  end

  describe "POST create" do
    before do
      ActionMailer::Base.deliveries.clear
    end

    it_behaves_like "require_not_login" do
      let(:action) { post :create }
    end

    context "with valid input" do
      let(:user) { Fabricate.build(:user) }
      before do
        StripeWrapper::Charge.stub(:create)
        post :create, user: {email: user.email, password: user.password, full_name: user.full_name}
      end

      it "creates user record" do
        expect(User.count).to eq(1)
        expect(User.first.email).to eq(user.email)
        expect(User.first.authenticate(user.password)).not_to eq(false)
        expect(User.first.full_name).to eq(user.full_name)
      end

      it "redirects to sign in path" do
        expect(response).to redirect_to sign_in_path
      end

      context "sends welcome email" do
        it "sends out the email" do
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it "sends to the signed up user" do
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to eq([user.email])
        end

        it "has the right content" do
          message = ActionMailer::Base.deliveries.last
          expect(message.body).to include(user.full_name)
        end
      end
    end

    context "with valid input and inviter" do
      let(:alice) { Fabricate(:user) }
      let(:invite_bob) { Fabricate(:invitation, inviter: alice) }
      before do
        StripeWrapper::Charge.stub(:create)
        post :create, invite_token: invite_bob.token, user: {
          email: invite_bob.email,
          password: "zbAdd",
          full_name: "Mr. bob"
          }
      end

      it "sets user follow the inviter" do
        bob = User.last
        expect(bob.followees.first).to eq(alice)
      end

      it "sets inviter follow the user" do
        bob = User.last
        expect(alice.followees.first).to eq(bob)
      end

      it "expires invitation record" do
        expect(Invitation.last.token).to be_nil
      end
    end

    context "with invalid input" do
      before do
        post :create, user: Fabricate.attributes_for(:invalid_user)
      end

      it "dose not create user record" do
        expect(User.count).to eq(0)
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "sets @user variable" do
        expect(assigns(:user)).to be_a_new(User)
      end

      it "does not sent out the email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET show" do
    before { set_user }
    let(:alice) {Fabricate(:user)}
    it_behaves_like "require_login" do
      let(:action) { get :show, id: alice.id }
    end

    it "sets @user variable" do
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end

    it "sets @queue_items variable" do
      get :show, id: alice.id
      expect(assigns(:queue_items)).to eq(alice.queue_items)
    end

    it "sets @reviews variable" do
      get :show, id: alice.id
      expect(assigns(:reviews)).to eq(alice.reviews)
    end
  end
end
