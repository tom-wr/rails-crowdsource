class TasksController < ApplicationController

  def index
    @tasks = Tasks.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
    @taskflow = Taskflow.find(params['taskflow_id'])
    @tasks = @taskflow.tasks
  end

  def create
    @task = Task.new(tasks_params)
    @taskflow = @task.taskflow

    if @task.save
      update_first_task(@taskflow, @task)
      redirect_to edit_taskflow_path(@taskflow)
    else
      render 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
    @taskflow = Taskflow.find(params['taskflow_id'])
    @tasks = @taskflow.tasks
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(tasks_params)
      @taskflow = @task.taskflow
      redirect_to edit_taskflow_path(@taskflow)
    else
      render 'new'
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @taskflow = @task.taskflow
    if(!@task.destroy)

    end
    redirect_to edit_taskflow_path(@taskflow)
  end

  private
    def tasks_params
      params.require(:task).permit(:title, :help, :task_type, :taskflow_id, data: [:text, :next])
    end

  private
    def update_first_task (taskflow, task)
      if !taskflow.first_task_id
        taskflow.update(first_task_id: task.id)
      end
    end
end
