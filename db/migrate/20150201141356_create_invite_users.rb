class CreateInviteUsers < ActiveRecord::Migration
  def change
    create_table :invite_users do |t|
      t.string :name
      t.string :email
      t.text :message
      t.string :token
      t.integer :inviter_id
      t.timestamps
    end
    add_index :invite_users, :inviter_id
  end
end
