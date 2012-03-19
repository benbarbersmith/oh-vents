class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.string :location
      t.string :details
      t.boolean :publicrsvp
      t.boolean :publicguestlist
      t.integer :user_id

      t.timestamps
    end
    add_index :events, [:user_id, :start_date]
  end

  def self.down
    drop_table :events
  end
end
