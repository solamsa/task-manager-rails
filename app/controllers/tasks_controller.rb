class TasksController < ApplicationController
  
  def index
    @tasks = current_user.tasks
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)


    if @task.save
      redirect_to @task
    else
      render :new, status: :unprocessable_entity
      puts @task.errors.full_messages
    end
  end

  def edit 
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    
    if @task.update(task_params)
      redirect_to @task
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to root_path, status: :see_other
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :due_date)
  end


end
