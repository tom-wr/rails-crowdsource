class SurveysController < ApplicationController
   def show
    @project_id = flash[:project_id]
    @survey = Survey.find(params[:id])
    file_name = "app/assets/surveys/" + @survey[:file] + ".json"
    @questions = JSON.parse( IO.read(file_name, encoding:'utf-8'))
  end
end
