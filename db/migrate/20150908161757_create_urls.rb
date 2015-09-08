class CreateUrls < ActiveRecord::Migration
  def self.up
    create_table :urls do |t|
      t.text :url, null: false
      t.integer :seen, null: false, default: 0
      t.string :key
      t.timestamps
    end
  end

  def self.down
    drop_table :urls
  end
end
