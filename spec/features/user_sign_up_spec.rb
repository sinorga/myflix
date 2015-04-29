require "spec_helper"

feature "User signs up" , js: true, vcr: true do
  background { visit register_path }
  scenario "signs up successfully with valid input" do
    fill_in_user_info
    fill_in_card_info("4242424242424242")

    click_on "Sign Up"
    #its used for waiting stripe done
    expect(page).to have_content("Sign in", wait: 20)

  end
  feature "with invalid user info" do
    background { fill_in_card_info("4242424242424242") }
    scenario "signs up failed when user name is blank" do
      bob = Fabricate.build(:user, full_name: "")
      fill_in_user_info(bob)
      click_on "Sign Up"
      expect(page).to have_content("Please check your input below.")
      expect(page).to have_content("can't be blank")
    end

    scenario "signs up failed when email have been used" do
      alice = Fabricate(:user, email: "alice@gmial.com")
      bob = Fabricate.build(:user, email: "alice@gmial.com")

      fill_in_user_info(bob)
      click_on "Sign Up"
      expect(page).to have_content("Please check your input below.")
      expect(page).to have_content("has already been taken")
    end
  end

  feature "with invalid card info" do
    background { fill_in_user_info }

    scenario "signs up failed when enter expired card number" do
      fill_in_card_info("4000000000000069")

      click_on "Sign Up"
      expect(page).to have_content("Your card has expired.", wait: 20)
    end

    scenario "signs up failed when enter declined card number" do
      fill_in_card_info("4000000000000002")

      click_on "Sign Up"
      expect(page).to have_content("Your card was declined.", wait: 20)
    end
  end

  def fill_in_user_info(user=nil)
    user ||= Fabricate.build(:user)

    fill_in("Email", with: user.email)
    fill_in("Password", with: user.password)
    fill_in("Full Name", with: user.full_name)
  end

  def fill_in_card_info(card_number)
    fill_in("Credit Card Number", with: card_number)
    fill_in("Security Code", with: "123")
    select("7 - July", from: "date_month")
    select("2019", from: "date_year")
  end
end
