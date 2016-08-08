class CreateDatasetAssignments < ActiveRecord::Migration
  def change
    create_table :dataset_assignments do |t|
      t.references :taskflow
      t.references :dataset
      t.timestamps null: false
    end
    add_index :dataset_assignments, ["taskflow_id", "dataset_id"]
  end
end
