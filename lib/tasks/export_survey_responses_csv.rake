
task :export_survey_responses_csv => :environment do

  CSV.open("survey_responses.csv", "wb") do | csv |

    @responses = SurveyResponse.all
    @responses.each do | response |
      csv << [response.id, response.session_id, response.data]
    end
  end
end
