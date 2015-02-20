
Fabricator(:user) do
  email { Faker::Internet.free_email }
  password { Faker::Internet.password }
  full_name { Faker::Name.name }
end

Fabricator(:invalid_user, from: :user) do
  email nil
  password { Faker::Internet.password }
  full_name { Faker::Name.name }
end

Fabricator(:admin, from: :user) do
  admin true
end
