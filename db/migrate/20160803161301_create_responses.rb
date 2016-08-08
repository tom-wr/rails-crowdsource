class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.string :session_id
      t.string :image_id
      t.string :data
      t.timestamps null: false
    end
  end
end
