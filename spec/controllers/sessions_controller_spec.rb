require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to home page for logged in user" do
      request.session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "with correct email and password" do
      let(:user) { Fabricate(:user) }
      before do
        post :create, email: user.email, password: user.password
      end

      it "signs in user" do
        expect(request.session[:user_id]).to eq(user.id)
      end

      it "flashes success message" do
        expect(flash[:success]).not_to eq(nil)
      end

      it "redirects to home page" do
        expect(response).to redirect_to home_path
      end
    end

    context "with unauthenticated user" do
      let(:user) { Fabricate(:user) }
      before do
        post :create, email: user.email, password: "wrong password"
      end

      it "flashes error message" do
        expect(flash[:danger]).not_to eq(nil)
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "DELETE destroy" do
    before do
      request.session[:user_id] = Fabricate(:user).id
      delete :destroy
    end

    it "logs out the signed in user" do
      expect(request.session[:user_id]).to eq(nil)
    end

    it "flashes success message" do
      expect(flash[:success]).not_to eq(nil)
    end
  end
end
