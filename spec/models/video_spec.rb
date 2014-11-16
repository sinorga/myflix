require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: "ID4", description: "hehehe")
    video.save
    expect(Video.first).to eq(video)
  end

  it "belongs to category" do
    tv = Category.create(name: "TV")
    sin_city = Video.create(title: "Sin City", description: "a great drama!", category: tv)

    expect(sin_city.category).to eq(tv)
  end

  it "does not save video without a title" do
    sin_city = Video.create(description: "a great drama!")
    expect(Video.count).to eq(0)
  end

  it "does not save video without a description" do
    sin_city = Video.create(title: "Sin City")
    expect(Video.count).to eq(0)
  end
end
