class Task < ActiveRecord::Base
  belongs_to :taskflow
  has_many :responses
  serialize :data
end
