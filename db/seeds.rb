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

videos = Video.create([
  {
    title: "T2: Judgment Day",
    description: "A cyborg, identical to the one who failed to kill Sarah Connor, must now protect her ten-year-old son, John, from a more advanced cyborg, made out of liquid metal.",
    large_cover_url: "/tmp/t2_large.jpg",
    small_cover_url: "/tmp/t2.jpg",
    category_id: (1..categories.count).to_a.sample
  },
  {
    title: "Futurama",
    description: "Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.",
    large_cover_url: "/tmp/monk_large.jpg",
    small_cover_url: "/tmp/monk.jpg",
    category_id: (1..categories.count).to_a.sample
  }
  ])
