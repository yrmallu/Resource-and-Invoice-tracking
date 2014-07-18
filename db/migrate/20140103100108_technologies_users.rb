class TechnologiesUsers < ActiveRecord::Migration
  def self.up
    create_table :technologies_users, :id => false do |t|
      t.integer :technology_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :technologies_users
  end
end
