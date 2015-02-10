
Fabricator(:invitation) do
  name { Faker::Name.name }
  email { Faker::Internet.free_email }
  message { Faker::Lorem.sentence }
end

Fabricator(:invalid_invitation, from: :invitation) do
  name nil
end
