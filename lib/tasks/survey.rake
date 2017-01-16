require "json"

namespace :survey do
  desc "TODO"
  task export: :environment do
    survey_json = File.read("./app/assets/surveys/survey_1.json")
    survey_hash = JSON.parse(survey_json)
    header = ["id", "project_id"]

    # create csv header from survey terms
    survey_hash["pages"].each do | page |
      page.each do | question |
        question["terms"].each do | term |
         t = ""
         if term.class == Hash
          t = term["term"]
         else
          t = term
         end
         header << t
        end
      end
    end

    CSV.open("survey_responses.csv", "wb") do | csv |
      csv << header
      SurveyResponse.all.each do |response|
        data = response["data"]
        paras = data["paras"]
        paras = paras.sort_by {|k,v| k.to_i}.to_h
        puts "****************************"
        puts response["session_id"]
        puts data["project_id"]
        #puts paras
        emotion = data["emotion"]
        emotion = emotion.sort_by {|k,v| k.to_i}.to_h
        puts "~"
        puts emotion
        #puts data["gender"]
        #puts data["age"]

        line = [response["session_id"], data["project_id"]]
        #csv << [response.id, response.session_id, response.data]
      end #surveyresponse each
    end #csvopen
  end #task export
end #namespace
