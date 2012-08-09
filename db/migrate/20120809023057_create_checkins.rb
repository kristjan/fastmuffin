class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer   :user_id,       :null => false
      t.string    :venue_id,      :null => false
      t.string    :venue_name,    :null => false
      t.timestamp :checked_in_at, :null => false

      t.timestamps
    end

    add_index :checkins, [:user_id, :venue_id]
    add_index :checkins, [:user_id, :checked_in_at], :unique => true
  end
end
