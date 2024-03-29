class TasksController < ApplicationController
  
  def index

    if params[:search]
      @tasks = current_user.tasks.order(due_date: :asc)
      .where("lower(title) LIKE ? OR lower(description) LIKE ?", "%#{params[:search].downcase}%","%#{params[:search].downcase}%")
      .page(params[:page])
      .per(5)
      # binding.pry
    elsif params[:status].present? && params[:status] != 'all'
      convert_status
      @tasks = current_user.tasks.where(status: params[:status]).order(due_date: :asc).page(params[:page]).per(5)
      # binding.pry
    elsif params[:highpriority].present?
      @tasks = current_user.tasks.order(due_date: :asc).todo.high.page(params[:page]).per(5)
    else
      @tasks = current_user.tasks.order(due_date: :asc).page(params[:page]).per(5)
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
    # binding.pry


    if @task.save
      respond_to do |format|
        format.html { redirect_to tasks_path, notice: "Quote was successfully created." }
        format.turbo_stream
      end
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
      respond_to do |format|
        format.html { redirect_to tasks_path, notice: "Task was successfully updated." }
        format.turbo_stream
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_path, notice: "Task was successfully destroyed." }
      format.turbo_stream
    end

    # redirect_to root_path, status: :see_other
  end


  def show_graph
    @tasks = generate_graph
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :due_date, :priority, :status , :estimate)
  end

  def convert_params
    params[:task][:priority] = params[:task][:priority].to_i
    params[:task][:status] = params[:task][:status].to_i
    params[:task][:estimate] = params[:task][:estimate].to_i
  end

  def convert_status
    params[:status] = params[:status].to_i
  end

  def generate_graph
    data_hash = {}
    data_points = []

    g = Gruff::Line.new(500)
    @tasks = current_user.tasks.order(created_at: :asc)
    num = 0
    @tasks.each do |task| 
      if task.actual_time.present?
        data_points << cal_estimate(task)
        data_hash[num] = num
        num += 1
      end
    end
    puts data_hash
    g.title = 'task estimate offset graph'
    g.data('Tasks', data_points)
    g.labels = data_hash
    g.x_axis_label = "Task"
    g.y_axis_label = " Estimate Offset %"
    send_data g.to_image.to_blob, type: 'image/png', disposition: 'inline'
  end

  def cal_estimate(task)
    data_point = (((task.actual_time.to_i - task.estimate.to_i).to_f/task.actual_time.to_i.abs()) * 100)
  end

end
