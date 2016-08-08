class SurveyResponse < ActiveRecord::Base
  belongs_to :survey
  serialize :data
end
