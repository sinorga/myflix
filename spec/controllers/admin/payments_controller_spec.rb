require 'spec_helper'

describe Admin::PaymentsController do
  describe "Get Index" do
    let(:payments) { Fabricate.times(5, :payment) }
    before do
      set_user(Fabricate(:admin))
      get :index
    end

    it "sets @payments variable" do
      expect(assigns(:payments)).to match_array(payments)
    end

    it "renders the index page" do
      expect(response).to render_template :index
    end
  end
end
