class AddMediaTypeToMedia < ActiveRecord::Migration
  def change
    add_column :media, :media_type_id, :integer
    add_column :media, :object_note, :string
    rename_column :media, :aam_file, :file
  end
end
