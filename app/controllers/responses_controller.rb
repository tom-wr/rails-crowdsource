class ResponsesController < ApplicationController

  def new
    @response = Response.new
    @task = Task.find(params[:task_id])
  end

  def create
    puts params[:response].merge(:session_id => session.id)
    response = Response.new(response_params)
    if response.save
      count = count_completed_responses
      if count < 10
        query = response_query()
        render :json => {
          task: query[:task],
          taskflow: query[:taskflow],
          count: count
        }
      else
        render :js => "window.location = '/surveys/1'"
      end
    end
  end

  def response_params
    params.require(:response).permit(:project_id, :session_id, :image_id, data: [:question, :answer])
  end

  def count_completed_responses
    if cookies[:completed] != nil
      cookies[:completed] = 1#cookies[:completed].to_i + 1
    else
      cookies[:completed] = 1
    end
    cookies[:completed].to_i
  end

  def response_query
    project = Project.find(params[:project_id])
    taskflow = project.taskflows.sample
    task = taskflow.first_task.slice("id", "data", "help", "title")
    taskflow = taskflow.slice("title", "id")
    results = {
      :task => task,
      :taskflow => taskflow
    }
  end

end
