class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :singly_id,    :null => false
      t.string :access_token, :null => false

      t.timestamps
    end
  end
end
