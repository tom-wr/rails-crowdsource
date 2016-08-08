class Taskflow < ActiveRecord::Base

  belongs_to :project
  has_many :tasks, dependent: :destroy
  has_many :dataset_assignments, dependent: :destroy
  has_many :datasets, :through => :dataset_assignments
  belongs_to :first_task, :class_name => "Task", :foreign_key => "first_task_id"

end
