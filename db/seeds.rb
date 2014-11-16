# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
videos = Video.create([
  {
    title: "T2: Judgment Day",
    description: "A cyborg, identical to the one who failed to kill Sarah Connor, must now protect her ten-year-old son, John, from a more advanced cyborg, made out of liquid metal.",
    large_cover_url: "/tmp/t2_large.jpg",
    small_cover_url: "/tmp/t2.jpg"
  }
  ])
