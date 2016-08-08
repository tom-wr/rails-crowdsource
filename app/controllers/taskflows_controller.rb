class TaskflowsController < ApplicationController
  def index
    @taskflows = Taskflow.all
  end

  def new
    @taskflow = Taskflow.new
    @project = Project.find(params[:project_id])
    @taskflows = @project.taskflows
    @datasets = @project.datasets
    @tasks = @taskflow.tasks
  end

  def create
    @taskflow = Taskflow.new(taskflow_create_params)
    if @taskflow.save
      redirect_to edit_taskflow_path(@taskflow)
    else
      render 'new'
    end
  end

  def edit
    @taskflow = Taskflow.find(params[:id])
    @tasks = @taskflow.tasks
    @project = @taskflow.project
    @taskflows = @project.taskflows
    @datasets = @project.datasets
  end

  def update
    @taskflow = Taskflow.find(params[:id])
    if @taskflow.update(taskflow_params)
      flash[:notice] = 'Taskflow successfully updated.'
      redirect_to edit_taskflow_path
    else
      redirect_to '/show'
    end
  end

  def destroy
    @taskflow = Taskflow.find(params[:id])
    @taskflow.destroy
    redirect_to edit_project_path(@taskflow.project)
  end

  private
    def taskflow_params
      params.require(:taskflow).permit(:title, :description, :first_task_id)
    end

  private
    def taskflow_create_params
      params.require(:taskflow).permit(:title, :description, :first_task, :project_id)
    end

end
