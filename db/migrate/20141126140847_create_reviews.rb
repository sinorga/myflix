class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :content
      t.integer :video_id
      t.integer :user_id
      t.timestamps
    end
    add_index :reviews, :user_id
    add_index :reviews, :video_id
  end
end
