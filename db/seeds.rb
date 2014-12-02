# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = Category.create([
  {name: "TV"},
  {name: "Movie"},
  {name: "Cartoon"}
  ])

users = Fabricate.times(5, :user)

Fabricate.times(20, :video) do
  category_id (1..categories.count).to_a.sample
  reviews { 20.times.map { Fabricate(:review) do
    user_id (1..users.count).to_a.sample
  end
  } }

  pic = ["t2", "monk"].sample
  large_cover_url "/tmp/#{pic}_large.jpg"
  small_cover_url "/tmp/#{pic}.jpg"
end
