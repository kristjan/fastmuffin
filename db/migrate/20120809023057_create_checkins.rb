class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer   :user_id
      t.string    :venue_id
      t.string    :venue_name
      t.timestamp :checked_in_at

      t.timestamps
    end

    add_index :checkins, [:user_id, :venue_id]
    add_index :checkins, [:user_id, :checked_in_at], :unique => true
  end
end
