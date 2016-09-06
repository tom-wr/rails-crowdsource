
task :export_responses_csv => :environment do

  CSV.open("response.csv", "wb") do | csv |

    @responses = Response.all
    @responses.each do | response |
      csv << [response.session_id, response.image_id, response.data]
    end
  end
end
