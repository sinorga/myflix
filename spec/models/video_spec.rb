require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: "ID4", description: "hehehe")
    video.save
    expect(Video.first).to eq(video)
  end
end
