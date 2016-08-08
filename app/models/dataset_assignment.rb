class DatasetAssignment < ActiveRecord::Base
  belongs_to :dataset
  belongs_to :taskflow
end

