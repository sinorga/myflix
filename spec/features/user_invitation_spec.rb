require "spec_helper"

feature "User invites friend" do
  scenario "user invite his friend successfully" do
    alice = Fabricate(:user)
    invite_bob = Fabricate.build(:invite_user)
    bob = Fabricate.build(:user, email: invite_bob.email)
    sign_in(alice)

    invite_a_friend(invite_bob)
    friend_registration_from_email(invite_bob)
    friend_sign_up(bob)

    expect_have_followed_relationship(alice, bob)
    expect_have_followed_relationship(bob, alice)
  end

  def invite_a_friend(invited_friend)
    click_on "Invite a friend"
    fill_in("Friend's Name", with: invited_friend.name)
    fill_in("Friend's Email Address", with: invited_friend.email)
    fill_in("Invitation Message", with: invited_friend.message)
    click_on "Send Invitation"
    sign_out
  end

  def friend_registration_from_email(invited_friend)
    open_email(invited_friend.email)
    expect(current_email).to have_content(invited_friend.name)
    expect(current_email).to have_content(invited_friend.message)
    current_email.click_link "Register"
  end

  def friend_sign_up(friend)
    expect_have_hidden_field('invite_token', InviteUser.last.token)
    expect_have_prefilled_email(friend)
    fill_in("Password", with: friend.password)
    fill_in("Full Name", with: friend.full_name)
    click_on "Sign Up"
    expect(current_path).to eq(sign_in_path)
  end

  def expect_have_prefilled_email(friend)
    expect(find_field('Email Address').value).to eq(friend.email)
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
