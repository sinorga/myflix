require "spec_helper"

feature "User resets passsword" do
  scenario "user resets passowrd successfully when he forgot" do
    alice = Fabricate(:user, password: "oldpassword")
    visit sign_in_path
    click_on "forgot password?"
    expect(current_path).to eq('/forgot_password')

    fill_in("Email Address", with: alice.email)
    click_on "Send Email"
    expect(current_path).to eq('/confirm_password_reset')

    open_email(alice.email)
    current_email.click_link "Reset Password"
    expect(current_path).to eq("/reset_password/#{alice.reload.password_reset_token}/edit")

    fill_in("New Password", with: "newpassword")
    click_on "Reset Password"
    expect(current_path).to eq('/sign_in')

    fill_in("Email Address", with: alice.email)
    fill_in("Password", with: "newpassword")
    click_on "Sign in"
    expect(current_path).to eq('/home')
  end
end
