class CreateQueueItems < ActiveRecord::Migration
  def change
    create_table :queue_items do |t|
      t.integer :position
      t.integer :user_id
      t.integer :video_id
      t.timestamps
    end
    add_index :queue_items, :user_id
    add_index :queue_items, :video_id
  end
end
