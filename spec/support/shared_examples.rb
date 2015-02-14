shared_examples "require_login" do
  it "redirects to sign in path for unauthenticate user" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "require_admin" do
  before { set_user }
  it_behaves_like "require_login"
  it "redirects to home path for normal user" do
    action
    expect(response).to redirect_to home_path
  end

  it "flashes danger message" do
    action
    expect(flash[:danger]).not_to be_blank
  end
end

shared_examples "require_not_login" do
  it "redirects to home path for authenticated user" do
    set_user
    action
    expect(response).to redirect_to home_path
  end
end

shared_examples "tokenable" do
  it "generates token before create" do
    expect(object.token).not_to be_nil
  end
end
