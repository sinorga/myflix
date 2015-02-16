
Fabricator(:video) do
  title { Faker::Lorem.words(5).join(" ") }
  description { Faker::Lorem.paragraph }
  large_cover { Rack::Test::UploadedFile.new(Dir[Rails.root.join('spec', 'fixtures', 'images', '*')].sample) }
  small_cover { Rack::Test::UploadedFile.new(Dir[Rails.root.join('spec', 'fixtures', 'images', '*')].sample) }
end

Fabricator(:invalid_video, from: :video) do
  title nil
end
