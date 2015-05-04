require "spec_helper"

feature "Admin view payments" do
  scenario "Admin can view payments" do
    sign_in(Fabricate(:admin))
    alice = Fabricate(:user)
    payment = Fabricate(:payment, amount: 999, user: alice)
    visit admin_payments_path

    expect(page).to have_content(alice.full_name)
    expect(page).to have_content(alice.email)
    expect(page).to have_content("$9.99")
    expect(page).to have_content(payment.stripe_charge_id)
  end

  scenario "users can not view payments" do
    sign_in(Fabricate(:user))
    alice = Fabricate(:user)
    payment = Fabricate(:payment, amount: 999, user: alice)
    visit admin_payments_path

    expect(page).not_to have_content(alice.full_name)
    expect(page).not_to have_content(alice.email)
    expect(page).not_to have_content("$9.99")
    expect(page).to have_content("You can't access this area.")
  end

end
