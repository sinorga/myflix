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
    queue_item1 = QueueItem.last

    visit video_path(video1)
    expect_button_not_to_be_seen("+ My Queue")

    add_video_to_queue(video2)
    queue_item2 = QueueItem.last
    add_video_to_queue(video3)
    queue_item3 = QueueItem.last

    set_queue_item_position(queue_item1, 3)
    set_queue_item_position(queue_item2, 1)
    set_queue_item_position(queue_item3, 2)

    update_queue

    expect_queue_item_postion(queue_item1, 3)
    expect_queue_item_postion(queue_item2, 1)
    expect_queue_item_postion(queue_item3, 2)

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
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_on "+ My Queue"
  end

  def set_queue_item_position(queue_item, position)
    fill_in "queue_items_#{queue_item.id}_position", with: position
  end

  def expect_queue_item_postion(queue_item, position)
    expect(find("input[id='queue_items_#{queue_item.id}_position']").value).to eq(position.to_s)
  end

end
