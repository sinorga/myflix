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

  def update_queue
    begin
      update_queue_items
    rescue
      flash[:danger] = "Invalid inputs."
    end

    normalize_queue_items
    redirect_to my_queue_path
  end

  def destroy
    queue_item = current_user.queue_items.find_by_id(params[:id])
    if queue_item.try(:destroy)
      normalize_queue_items
    end
    redirect_to my_queue_path
  end

  private
  def update_queue_items
    QueueItem.transaction do
      params[:queue_items].each do |key, value|
        queue_item = current_user.queue_items.find(key)
        queue_item.update!(position: value[:position])
      end
    end
  end

  def normalize_queue_items
    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index+1)
    end
  end
end
