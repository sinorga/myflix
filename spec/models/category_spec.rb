require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.new(name: "TV")
    category.save
    expect(Category.first).to eq(category)
  end

  it "has many videos" do
    tv = Category.create(name: "TV")
    sin_city = Video.create(title: "Sin City", description: "a great drama!", category: tv)
    scandal = Video.create(title: "Scandal", description: "a good video!", category: tv)

    expect(tv.videos).to eq([scandal, sin_city])
  end
end
