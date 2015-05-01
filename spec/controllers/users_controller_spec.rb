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
      let(:registrator) { double(:registrator, success?: true) }
      before do
        expect(UserRegistrator).to receive(:new)
          .with(an_instance_of(User))
          .and_return(registrator)
        expect(registrator).to receive(:register).with("xxxxxxxxxxxxx", nil)
          .and_return(registrator)

        post :create, user: {
          email: user.email,
          password: user.password,
          full_name: user.full_name
        }, stripeToken: "xxxxxxxxxxxxx"
      end

      it "redirects to sign in path" do
        expect(response).to redirect_to sign_in_path
      end

      it "flashes success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "with valid input and inviter" do
      let(:alice) { Fabricate(:user) }
      let(:invite_bob) { Fabricate(:invitation, inviter: alice) }
      let(:registrator) { double(:registrator, success?: true) }

      it "calls UserRegistrator to connect friendshop" do
        expect(UserRegistrator).to receive(:new)
          .with(an_instance_of(User))
          .and_return(registrator)
        expect(registrator).to receive(:register).with("xxxxxxxxxxxxx", invite_bob.token)
          .and_return(registrator)

        post :create, invite_token: invite_bob.token, user: {
          email: invite_bob.email,
          password: "zbAdd",
          full_name: "Mr. bob"
        }, stripeToken: "xxxxxxxxxxxxx"
      end
    end

    context "with valid personal info and declined card" do
      let(:registrator) do
        double(:registrator, success?: false, card_error?: true, message: "card error!")
      end
      before do
        expect(UserRegistrator).to receive(:new)
          .with(an_instance_of(User))
          .and_return(registrator)
        expect(registrator).to receive(:register).with("12341234", nil)
          .and_return(registrator)

        post :create, user: Fabricate.attributes_for(:user), stripeToken: "12341234"
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "sets @user variable" do
        expect(assigns(:user)).to be_a_new(User)
      end

      it "flash danger message" do
        expect(flash[:danger]).to be_present
      end
    end

    context "with invalid personal info and valid card" do
      let(:registrator) do
        double(:registrator, success?: false, card_error?: false)
      end
      before do
        expect(UserRegistrator).to receive(:new)
          .with(an_instance_of(User))
          .and_return(registrator)
        expect(registrator).to receive(:register).with("xxxxxxxxxxxxx", nil)
          .and_return(registrator)

        post :create, user: Fabricate.attributes_for(:invalid_user), stripeToken: "xxxxxxxxxxxxx"
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "sets @user variable" do
        expect(assigns(:user)).to be_a_new(User)
      end

      it "does not flash danger message" do
        expect(flash[:danger]).to be_blank
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
