class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :category
      t.string :name
      t.references :parent, index: true
      t.timestamps null: false
    end
  end
end
