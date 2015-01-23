require 'spec_helper'

feature "User interacts with the queue" do
  background { sign_in }

  scenario "user adds and reorders video in the queue" do
    tv = Fabricate(:category, name: "TV")
    video1 = Fabricate(:video, category: tv)
    video2 = Fabricate(:video, category: tv)
    video3 = Fabricate(:video, category: tv)

    add_video_to_queue(video1)
    expect_video_to_be_in_queue(video1)

    visit video_path(video1)
    expect_button_not_to_be_seen("+ My Queue")

    add_video_to_queue(video2)
    add_video_to_queue(video3)

    set_video_position(video1, 3)
    set_video_position(video2, 1)
    set_video_position(video3, 2)

    update_queue

    expect_video_postion(video1, 3)
    expect_video_postion(video2, 1)
    expect_video_postion(video3, 2)

  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def expect_button_not_to_be_seen(btn_text)
    expect(page).not_to have_content(btn_text)
  end

  def update_queue
    click_on "Update Instant Queue"
  end

  def add_video_to_queue(video)
    click_video_on_home_page(video)
    click_on "+ My Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      find("input[id$='_position']").set(position)
    end
  end

  def expect_video_postion(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end

end
