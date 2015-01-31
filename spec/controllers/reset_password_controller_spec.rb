require 'spec_helper'

describe ResetPasswordController do
  describe "GET edit" do
    it_behaves_like "require_not_login" do
      let(:action) { get :edit, id: "xxxxxxxxxxxx" }
    end

    it "sets @user variable if token is vaild" do
      alice = Fabricate(:user)
      alice.generate_password_reset_token
      get :edit, id: alice.password_reset_token
      expect(assigns(:user)).to eq(alice)
    end

    it "redirects to invalid token page if token is invalid" do
      get :edit, id: "xxxxxxxxxxxx"
      expect(response).to redirect_to invalid_token_path
    end
  end

  describe "PUT update" do
    it_behaves_like "require_not_login" do
      let(:action) { put :update, id: "xxxxxxxxxxxx" }
    end

    it "redirects to invalid token page if token is invalid" do
      put :update, id: "xxxxxxxxxxxx"
      expect(response).to redirect_to invalid_token_path
    end

    context "with vaild password" do
      let(:alice) { Fabricate(:user, password: "oldpw") }
      before do
        alice.generate_password_reset_token
        put :update, id: alice.password_reset_token, password: "newpassword"
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
        put :update, id: alice.password_reset_token, password: nil
        alice.reload
      end

      it "renders the edit_password page" do
        expect(response).to render_template :edit
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
