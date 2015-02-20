require 'spec_helper'

describe AdminsController do
  controller(AdminsController) do
    def new
    end
  end

  describe "GET new" do
    it_behaves_like "require_admin" do
      let(:action) { get :new }
    end
  end
end
