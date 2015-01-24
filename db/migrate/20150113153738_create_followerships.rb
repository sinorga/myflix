class CreateFollowerships < ActiveRecord::Migration
  def change
    create_table :followerships do |t|
      t.integer :follower_id
      t.integer :followee_id
      t.timestamps
    end
    add_index :followerships, :follower_id
    add_index :followerships, :followee_id
  end
end
