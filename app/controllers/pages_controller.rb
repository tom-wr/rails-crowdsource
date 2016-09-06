class PagesController < ApplicationController

  def home
  end

  def start
    cookies[:completed] = 0
  end

  def tutorial

  end

  def visual_counter

  end

  def classify
    @project = Project.find(params[:id])
    @taskflow = @project.taskflows.sample
    @task = @taskflow.first_task
  end

end
