class Dataset < ActiveRecord::Base
  has_many :dataset_assignments, dependent: :destroy
  has_many :taskflows, :through => :dataset_assignments
  belongs_to :project
  has_many :media, dependent: :destroy
end
