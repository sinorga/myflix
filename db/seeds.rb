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

users = Fabricate.times(3, :user)
ooo_user = User.create(email: "ooo@gmail.com", password: "123456", full_name: "Mr. Ooo")
users << ooo_user

videos = Fabricate.times(20, :video) do
  category_id (1..categories.count).to_a.sample

  pic = ["t2", "monk"].sample
  large_cover_url "/tmp/#{pic}_large.jpg"
  small_cover_url "/tmp/#{pic}.jpg"
end

reviews = Fabricate.times(100, :review) do
  video videos.sample
  user users.sample
end

queue_items = 10.times.each do |i|
  QueueItem.create(video: videos[i], user: ooo_user, position: i)
end
