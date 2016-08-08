module TasksHelper

  def next_task_options(tasks)
    task_options = tasks.collect {|t| [t.title, t.id]}
    task_options = task_options.unshift(["End classification", 0])
  end

end
