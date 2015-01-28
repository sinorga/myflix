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

  describe "GET forgot_password" do
    it_behaves_like "require_not_login" do
      let(:action) { get :forgot_password }
    end
  end

  describe "POST confirm_password_reset" do
    it_behaves_like "require_not_login" do
      let(:action) { post :confirm_password_reset }
    end
    
    context "with valid email" do
      let(:alice) { Fabricate(:user) }
      before do
        post :confirm_password_reset, email: alice.email
        alice.reload
      end

      it "renders to confirm password reset page" do
        expect(response).to render_template :confirm_password_reset
      end

      it "generates and save the random token for reset password" do
        expect(alice.password_reset_token).not_to be_nil
      end

      it "sends out the email" do
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends out email with reset password link" do
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include(new_reset_password_path(alice.password_reset_token))
      end
    end

    context "with invalid email" do
      before do
        ActionMailer::Base.deliveries.clear
        post :confirm_password_reset, email: "nobody@xxx.com"
      end

      it "renders forgot_password page" do
        expect(response).to render_template :forgot_password
      end

      it "flashes error message" do
        expect(flash[:danger]).to be_present
      end

      it "does not send out email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET new_reset_password" do
    it_behaves_like "require_not_login" do
      let(:action) { get :new_reset_password, token: "xxxxxxxxxxxx" }
    end

    it "sets @user variable if token is vaild" do
      alice = Fabricate(:user)
      alice.generate_password_reset_token
      get :new_reset_password, token: alice.password_reset_token
      expect(assigns(:user)).to eq(alice)
    end

    it "raise not found error if token is invalid" do
      expect{
        get :new_reset_password, token: "xxxxxxxxxxxx"
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "POST reset_password" do
    it_behaves_like "require_not_login" do
      let(:action) { post :reset_password, token: "xxxxxxxxxxxx" }
    end

    it "raise not found error if token is invalid" do
      expect{
        post :reset_password, token: "xxxxxxxxxxxx"
      }.to raise_error(ActionController::RoutingError)
    end

    it "raise not found error if token is nil" do
      expect{
        post :reset_password, token: nil
      }.to raise_error(ActionController::RoutingError)
    end

    context "with vaild password" do
      let(:alice) { Fabricate(:user, password: "oldpw") }
      before do
        alice.generate_password_reset_token
        post :reset_password, token: alice.password_reset_token, password: "newpassword"
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
    end

    context "with invalid password" do
      let(:alice) { Fabricate(:user, password: "oldpw") }
      before do
        alice.generate_password_reset_token
        post :reset_password, token: alice.password_reset_token, password: nil
        alice.reload
      end

      it "renders the new_reset_password page" do
        expect(response).to render_template :new_reset_password
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
