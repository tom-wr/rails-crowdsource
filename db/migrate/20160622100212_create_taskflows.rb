class CreateTaskflows < ActiveRecord::Migration
  def change
    create_table :taskflows do |t|
      t.string :title
      t.string :description
      t.belongs_to :project
      t.references :first_task
      t.timestamps null: false
    end
  end
end
