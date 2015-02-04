class CreateInviteUsers < ActiveRecord::Migration
  def change
    create_table :invite_users do |t|
      t.string :name
      t.string :email
      t.text :message
      t.string :token
      t.integer :user_id
      t.timestamps
    end
    add_index :invite_users, :user_id
  end
end
