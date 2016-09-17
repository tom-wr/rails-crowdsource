class SurveyResponsesController < ApplicationController

  def new
    @survey_response = SurveyResponse.new
  end

  def create
    params[:survey].merge(:session_id => session.id)
    response = Hash[
      "session_id" => session.id,
      "data" => params[:survey][:data]
    ]

    puts response
    @survey_response = SurveyResponse.create(response)

  end

  def survey_response_params
    params.require('survey').permit(:session_id, :project_id, data: [ paras:[], emotion:[], gender:[], age:[] ] )
  end

end
