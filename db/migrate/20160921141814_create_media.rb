class CreateMedia < ActiveRecord::Migration
  def change
    drop_table :media
    create_table :media do |t|
      t.integer :aam_id
      t.string :mime_type
      t.string :aam_file
      t.string :accession_number
      t.string :caption
      t.string :caption_alt
      t.string :identifier
      t.string :place
      t.string :place_id
      t.string :object_id
      t.string :actor_appellation
      t.string :collection
      t.timestamps null: false
    end
  end
end
