require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user variable" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do
    before do
      ActionMailer::Base.deliveries.clear
    end
    context "with valid input" do
      let(:user) { Fabricate.build(:user) }
      before do
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

  describe "GET edit_password" do
    it_behaves_like "require_not_login" do
      let(:action) { get :edit_password, password_reset_token: "xxxxxxxxxxxx" }
    end

    it "sets @user variable if token is vaild" do
      alice = Fabricate(:user)
      alice.generate_password_reset_token
      get :edit_password, password_reset_token: alice.password_reset_token
      expect(assigns(:user)).to eq(alice)
    end

    it "redirects to invalid token page if token is invalid" do
      get :edit_password, password_reset_token: "xxxxxxxxxxxx"
      expect(response).to redirect_to invalid_token_path
    end
  end

  describe "POST reset_password" do
    it_behaves_like "require_not_login" do
      let(:action) { post :reset_password, password_reset_token: "xxxxxxxxxxxx" }
    end

    it "redirects to invalid token page if token is invalid" do
      post :reset_password, password_reset_token: "xxxxxxxxxxxx"
      expect(response).to redirect_to invalid_token_path
    end

    context "with vaild password" do
      let(:alice) { Fabricate(:user, password: "oldpw") }
      before do
        alice.generate_password_reset_token
        post :reset_password, password_reset_token: alice.password_reset_token, user: { password: "newpassword"}
        alice.reload
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end

      it "updates password of the user" do
        expect(alice.authenticate("newpassword")).to be_truthy
      end

      it "clears the password_reset_token of the user" do
        expect(alice.password_reset_token).to be_nil
      end

      it "flashes success message" do
        expect(flash[:success]).not_to be_empty
      end
    end

    context "with invalid password" do
      let(:alice) { Fabricate(:user, password: "oldpw") }
      before do
        alice.generate_password_reset_token
        post :reset_password, password_reset_token: alice.password_reset_token, user: { password: nil}
        alice.reload
      end

      it "renders the edit_password page" do
        expect(response).to render_template :edit_password
      end

      it "flashes error message" do
        expect(flash[:danger]).not_to be_empty
      end

      it "does not update password of the user" do
        expect(alice.authenticate("oldpw")).to be_truthy
      end

      it "keeps the password_reset_token of the user" do
        expect(alice.password_reset_token).not_to be_nil
      end
    end
  end
end
