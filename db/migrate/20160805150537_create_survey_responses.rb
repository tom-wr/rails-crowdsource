class CreateSurveyResponses < ActiveRecord::Migration
  def change
    create_table :survey_responses do |t|
      t.string :session_id
      t.string :data
      t.timestamps null: false
    end
  end
end
