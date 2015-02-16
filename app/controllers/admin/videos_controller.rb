class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You have added video #{@video.title} successfully!"
      redirect_to new_admin_video_path
    else
      flash[:danger] = "Invalid input!"
      render :new
    end
  end

  protected
  def video_params
    params.require(:video).permit(:title, :category_id, :description, :large_cover, :small_cover)
  end
end
