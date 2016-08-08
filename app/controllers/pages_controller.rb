class PagesController < ApplicationController

  def home
  end

  def start
  end

  def classify
    @project = Project.find(params[:id])
    @taskflow = @project.taskflows.sample
    @task = @taskflow.first_task
  end

end
