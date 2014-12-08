module QueueItemsHelper
  def add_my_queue_btn(video)
    unless current_user.queued_video? video
      link_to "+ My Queue", video_queue_items_path(video), method: :post, class: "btn btn-default"
    end
  end
end
