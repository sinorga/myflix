def sign_in_user
  session[:user_id] = Fabricate(:user).id
end

def user
  User.find(session[:user_id])
end
