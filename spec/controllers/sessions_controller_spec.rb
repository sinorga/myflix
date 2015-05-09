require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to home page for authenticated in user" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end

    it "renders the :new template for unauthenticated user" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    context "with vaild credentials" do
      before do
        post :create, email: user.email, password: user.password
      end
      context "with activated user" do
        let(:user) { Fabricate(:user) }

        it "signs in the user in the session" do
          expect(session[:user_id]).to eq(user.id)
        end

        it "flashes success message" do
          expect(flash[:success]).not_to be_blank
        end

        it "redirects to home page" do
          expect(response).to redirect_to home_path
        end
      end
      context "with locked user" do
        let(:user) { Fabricate(:locked_user) }

        it "does not sign in user in the session" do
          expect(session[:user_id]).to be_nil
        end

        it "flashes error message" do
          expect(flash[:danger]).not_to be_blank
        end

        it "redirects to sign in page" do
          expect(response).to redirect_to sign_in_path
        end
      end
    end

    context "with invalid credentials" do
      let(:user) { Fabricate(:user) }
      before do
        post :create, email: user.email, password: "wrong password"
      end

      it "does not sign in user in the session" do
        expect(session[:user_id]).to be_nil
      end

      it "flashes error message" do
        expect(flash[:danger]).not_to be_blank
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it "clear the session for the user" do
      expect(request.session[:user_id]).to be_nil
    end

    it "flashes success message" do
      expect(flash[:success]).not_to be_blank
    end

    it "redirects to root path" do
      expect(response).to redirect_to root_path
    end
  end
end
