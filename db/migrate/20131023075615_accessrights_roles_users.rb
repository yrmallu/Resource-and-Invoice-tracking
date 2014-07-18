class AccessrightsRolesUsers < ActiveRecord::Migration
  
  def self.up
    create_table :accessrights_roles_users, :id => false do |t|
      t.integer :accessright_id
      t.integer :role_id
	  t.integer :user_id
    end
  end

  def self.down
    drop_table :accessrights_roles_users
  end
  
end
