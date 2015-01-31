require 'spec_helper'

describe ForgotPasswordController do
  describe "GET new" do
    it_behaves_like "require_not_login" do
      let(:action) { get :new }
    end
  end

  describe "POST confirm" do
    it_behaves_like "require_not_login" do
      let(:action) { post :confirm }
    end

    context "with valid email" do
      let(:alice) { Fabricate(:user) }
      before do
        post :confirm, email: alice.email
        alice.reload
      end

      it "generates and save the random token for reset password" do
        expect(alice.password_reset_token).not_to be_nil
      end

      it "sends out the email to the user" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([alice.email])
      end

      it "sends out email with reset password link" do
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include(edit_password_path(alice.password_reset_token))
      end
    end

    context "with invalid email" do
      before do
        ActionMailer::Base.deliveries.clear
        post :confirm, email: "nobody@xxx.com"
      end

      it "renders forgot_password page" do
        expect(response).to render_template :new
      end

      it "flashes error message" do
        expect(flash[:danger]).to be_present
      end

      it "does not send out email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
