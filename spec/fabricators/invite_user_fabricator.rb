
Fabricator(:invite_user) do
  name { Faker::Name.name }
  email { Faker::Internet.free_email }
  message { Faker::Lorem.sentence }
end

Fabricator(:invalid_invite_user, from: :invite_user) do
  name nil
end
