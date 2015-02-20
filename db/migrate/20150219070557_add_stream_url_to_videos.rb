class AddStreamUrlToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :stream_url, :string
  end
end
