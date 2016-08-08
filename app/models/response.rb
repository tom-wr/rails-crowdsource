class Response < ActiveRecord::Base
  belongs_to :project
  serialize :data
end
