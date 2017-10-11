class ResponsesController < ApplicationController

  def new
    @response = Response.new
    @task = Task.find(params[:task_id])
  end

  def create
    params[:response][:session_id] = session[:guest_user_id]
    response = Response.new(response_params)
    if response.save
      count = count_completed_responses
      if count < 99
        query = response_query()
        render :json => {
          task: query[:task],
          taskflow: query[:taskflow],
          count: count
        }
      else
        redirect to "/"
        #redirect_to "/surveys/1", flash: { project_id: params[:project_id]}
      end
    end
  end

  def response_params
    p session[:guest_user_id]
    p params[:response][:session_id]
    params.require(:response).permit(:project_id, :session_id, :image_id, data: [:question, :caption, answer: [] ])
  end

  def count_completed_responses
    if cookies[:completed] != nil
      cookies[:completed] = cookies[:completed].to_i + 1
    else
      cookies[:completed] = 1
    end
    cookies[:completed].to_i
  end

  def response_query
    project = Project.find(params[:project_id])
    taskflow = project.taskflows.sample
    task = taskflow.first_task.slice("id", "data", "help", "title", "task_type")
    taskflow = taskflow.slice("title", "id")
    results = {
      :task => task,
      :taskflow => taskflow
    }
  end

end
