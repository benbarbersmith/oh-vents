class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.datetime :startdate
      t.datetime :enddate
      t.string :location
      t.string :details
      t.boolean :publicrsvp
      t.boolean :publicguestlist

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
