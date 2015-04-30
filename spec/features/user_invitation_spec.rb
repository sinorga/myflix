require "spec_helper"

feature "User invites friend" do
  scenario "user invite his friend successfully", js: true, vcr: true do
    alice = Fabricate(:user)
    invite_bob = Fabricate.build(:invitation)
    bob = Fabricate.build(:user, email: invite_bob.email)
    sign_in(alice)

    invite_a_friend(invite_bob)
    friend_registration_from_email(invite_bob)
    friend_sign_up(bob)

    expect_have_followed_relationship(alice, bob)
    expect_have_followed_relationship(bob, alice)
  end

  def invite_a_friend(invited_friend)
    visit invite_path
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
    expect_have_hidden_field('invite_token', Invitation.last.token)
    expect_have_prefilled_email(friend)
    fill_in("Password", with: friend.password)
    fill_in("Full Name", with: friend.full_name)
    fill_in("Credit Card Number", with: "4242424242424242")
    fill_in("Security Code", with: "123")
    select("7 - July", from: "date_month")
    select("2019", from: "date_year")
    click_on "Sign Up"
    #its used for waiting stripe done
    expect(page).to have_content("Sign in", wait: 20)
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
