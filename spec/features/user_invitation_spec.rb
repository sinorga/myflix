require "spec_helper"

feature "User invites friend" do
  scenario "user invite his friend successfully" do
    alice = Fabricate(:user)
    invite_bob = Fabricate.build(:invite_user)
    bob = Fabricate.build(:user, email: invite_bob.email)
    sign_in(alice)

    visit invite_path
    fill_in("Friend's Name", with: invite_bob.name)
    fill_in("Friend's Email Address", with: invite_bob.email)
    fill_in("Invitation Message", with: invite_bob.message)
    click_on "Send Invitation"
    sign_out

    open_email(invite_bob.email)
    expect(current_email).to have_content(invite_bob.name)
    expect(current_email).to have_content(invite_bob.message)
    current_email.click_link "Register"

    expect_have_hidden_field('invite_token', InviteUser.last.token)
    expect_have_prefilled_email(invite_bob)
    fill_in("Password", with: bob.password)
    fill_in("Full Name", with: bob.full_name)
    click_on "Sign Up"
    expect(current_path).to eq("/sign_in")

    expect_have_followed_relationship(alice, bob)
    expect_have_followed_relationship(bob, alice)
  end

  def expect_have_prefilled_email(invite_user)
    expect(find_field('Email Address').value).to eq(invite_user.email)
  end

  def expect_have_hidden_field(id, value)
    expect(find("input\##{id}", visible: false).value).to eq(value)
  end

  def expect_have_followed_relationship(follower, leader)
    sign_in(follower)
    click_on "People"
    expect(page).to have_content(leader.full_name)
    sign_out
  end
end
