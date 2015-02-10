class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :name
      t.string :email
      t.text :message
      t.string :token
      t.integer :inviter_id
      t.timestamps
    end
    add_index :invitations, :inviter_id
  end
end
