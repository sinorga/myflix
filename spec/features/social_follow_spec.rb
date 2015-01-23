require 'spec_helper'

feature "social network follow behaviors" do
  scenario "user follows other user" do
    alice = Fabricate(:user)
    bob = Fabricate(:user)
    tv = Fabricate(:category, name: "TV")
    video1 = Fabricate(:video, category: tv)
    review = Fabricate(:review, user: bob, video: video1)

    sign_in alice
    visit home_path
    click_video(video1)
    click_user_of_review(bob)
    expect(page).to have_content "#{bob.full_name}'s video collections"
    click_on 'Follow'
    expect(page).to have_content "People I Follow"
    expect(page).to have_content bob.full_name
    click_unfollow(bob)
    expect(page).not_to have_content bob.full_name
  end

  def click_user_of_review(user)
    find("article.review").click_link user.full_name
  end

  def click_video(video)
    find("a[href='#{video_path(video)}']").click
  end
  def click_unfollow(user)
    find("td a[href='#{followee_path(user)}']").click
  end
end
