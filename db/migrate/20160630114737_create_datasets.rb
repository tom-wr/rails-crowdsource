class CreateDatasets < ActiveRecord::Migration
  def change
    create_table :datasets do |t|
      t.string :title
      t.string :description
      t.belongs_to :project
      t.timestamps null: false
    end
  end
end
