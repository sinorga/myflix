class QueueItemsController < ApplicationController
  before_action :require_user
  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    QueueItem.create(video: video, user: current_user)
    redirect_to my_queue_path
  end

  def update
    begin
      QueueItem.transaction do
        params[:queue_items].each do |key, value|
          queue_item = current_user.queue_items.find(key)
          if queue_item
            queue_item.update!(position: value[:position])
          end
        end
      end
    rescue
    end
    redirect_to my_queue_path
  end

  def destroy
    queue_item = current_user.queue_items.find_by_id(params[:id])
    if queue_item
      queue_item.destroy
    end
    redirect_to my_queue_path
  end
end
