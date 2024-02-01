class TasksController < ApplicationController
  
  def index
    if params[:search]
      @tasks = current_user.tasks.where("title LIKE ? or description LIKE ?", "%#{params[:search]}%","%#{params[:search]}%").page(params[:page]).per(5)
    else
      @tasks = current_user.tasks.page(params[:page]).per(5)
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    # binding.pry
    convert_params
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

    convert_params
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
    params.require(:task).permit(:title, :description, :due_date, :priority, :status)
  end

  def convert_params
    params[:task][:priority] = params[:task][:priority].to_i
    params[:task][:status] = params[:task][:status].to_i
  end


end
