class AccessrightsRoles < ActiveRecord::Migration

  def self.up
    create_table :accessrights_roles, :id => false do |t|
      t.integer :accessright_id
      t.integer :role_id
    end
  end

  def self.down
    drop_table :accessrights_roles
  end
  
end
