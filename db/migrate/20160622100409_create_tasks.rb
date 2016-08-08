class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.integer :task_type
      t.text :help
      t.text :data
      t.belongs_to :taskflow
      t.timestamps null: false
    end
  end
end
