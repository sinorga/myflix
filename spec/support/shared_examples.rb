shared_examples "require_login" do
  it "redirects to sign in path for unauthenticate user" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "require_not_login" do
  it "redirects to home path for authenticated user" do
    set_user
    action
    expect(response).to redirect_to home_path
  end
end
