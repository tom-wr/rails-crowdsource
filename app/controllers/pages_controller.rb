class PagesController < ApplicationController

  def home
    session[:guest_user_id] = nil
  end

  def start
    @condition = params[:condition]
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

  def profile
    #grab the username from the URL as :id
    @user = User.find_by_username(params[:id])
    if @user == nil
      redirect_to root_path, :notice=> "User not found!"
    end

  end

end
