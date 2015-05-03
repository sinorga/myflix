Fabricator(:payment) do
  amount { Faker::Number.number(3) }
  stripe_charge_id { Faker::Lorem.characters(10) }
  user
end
