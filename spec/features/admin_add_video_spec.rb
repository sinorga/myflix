require "spec_helper"

feature "Admin adds new video" do
  scenario "Admin adds new video successfully" do
    category = Fabricate(:category)
    sign_in(Fabricate(:admin))
    visit new_admin_video_path

    new_video = Fabricate.build(:video, category: category)
    add_new_video(new_video)
    sign_out

    sign_in
    visit video_path(Video.first)
    expect_large_cover_image_on_video_page(new_video)
    expect_stream_url_on_video_page(new_video)
  end

  def add_new_video(new_video)
    fill_in 'Title', with: new_video.title
    select new_video.category.name, from: 'Category'
    fill_in 'Description', with: new_video.description
    attach_file 'Large Cover', new_video.large_cover_url
    attach_file 'Small Cover', new_video.small_cover_url
    fill_in 'Stream URL', with: new_video.stream_url
    click_on 'Add Video'
    expect(page).to have_content("You have added video #{new_video.title} successfully!")
  end

  def expect_large_cover_image_on_video_page(new_video)
    expect(page).to have_selector("img[src='#{File.join(Rails.root, "tmp", "uploads", "files", new_video.large_cover.identifier)}']")
  end

  def expect_stream_url_on_video_page(new_video)
    expect(page).to have_selector("a[href='#{new_video.stream_url}']")
  end
end
