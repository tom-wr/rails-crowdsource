class SurveyResponsesController < ApplicationController

  def new
    @survey_response = SurveyResponse.new
  end

  def create

    response = Hash[
      "session_id" => session[:guest_user_id],
      "data" => params[:survey][:data]
    ]
    @survey_response = SurveyResponse.create(response)

  end

  def survey_response_params
    params.require('survey').permit(:session_id, :project_id, data: [ paras:[], emotion:[], gender:[], age:[] ] )
  end

end
