require "rails_helper"

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }

  before do
    sign_in user
  end

  describe "GET index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns tasks for the current user to @tasks" do
      get :index
      expect(assigns(:tasks)).to eq(user.tasks)
    end

    context "with search parameter" do
      it "returns tasks matching the search query" do
        task_with_search_term = create(:task, user: user, title: "SearchTermTask", description:"this is a search test description")

        get :index, params: { search: "SearchTerm" }

        expect(assigns(:tasks)).to include(task_with_search_term)
      end
    end

    context "without search parameter" do
      it "returns all tasks for the current user" do
        get :index
        expect(assigns(:tasks)).to eq([task])
      end
    end
  end

  it "should have a current_user" do
    expect(subject.current_user).to_not eq(nil)
  end

  it "should return 200:OK" do
    get :index
    expect(response).to have_http_status(:success)
  end

  describe 'POST #destroy' do
    it 'Task is valid' do
      expect(task).to be_valid
    end

    it 'checks that a task can be destroyed' do
      task 
      expect { delete :destroy, params: { id: task.id } }.to change(Task, :count).by(-1)
    end
  end

  describe '#todo' do
    it 'orders tasks by due date and paginates them' do
      # Create some tasks with due dates in different orders
      task1 = create(:task, user: user, due_date: 3.days.from_now ,status: 0)
      task2 = create(:task, user: user, due_date: 1.day.from_now, status: 0)
      task3 = create(:task, user: user, due_date: 2.days.from_now, status: 0)

      # binding.pry

      get :todo

      expect(assigns(:tasks)).to eq([task2, task3, task1]) # Assuming ascending order
      expect(assigns(:tasks).current_page).to eq(1)
      expect(assigns(:tasks).limit_value).to eq(5) # Per(5) from your controller
    end
  end

  describe '#inprogress' do
    it 'orders tasks by due date and paginates them' do
      # Create some tasks with due dates in different orders
      task1 = create(:task, user: user, due_date: 3.days.from_now ,status: 1)
      task2 = create(:task, user: user, due_date: 1.day.from_now, status: 1)
      task3 = create(:task, user: user, due_date: 2.days.from_now, status: 1)

      # binding.pry

      get :inprogress

      expect(assigns(:tasks)).to eq([task2, task3, task1])
      expect(assigns(:tasks).current_page).to eq(1)
      expect(assigns(:tasks).limit_value).to eq(5)
    end
  end

  describe '#complete' do
    it 'orders tasks by due date and paginates them' do
      # Create some tasks with due dates in different orders
      task1 = create(:task, user: user, due_date: 3.days.from_now ,status: 2)
      task2 = create(:task, user: user, due_date: 1.day.from_now, status: 2)
      task3 = create(:task, user: user, due_date: 2.days.from_now, status: 2)

      # binding.pry

      get :complete

      expect(assigns(:tasks)).to eq([task2, task3, task1])
      expect(assigns(:tasks).current_page).to eq(1)
      expect(assigns(:tasks).limit_value).to eq(5)
    end
  end

  describe '#highpriority' do
    it 'orders tasks by due date and paginates them' do
      # Create some tasks with due dates in different orders
      task1 = create(:task, user: user, due_date: 3.days.from_now ,status: 0 ,priority: 2)
      task2 = create(:task, user: user, due_date: 1.day.from_now, status: 2, priority: 1)
      task3 = create(:task, user: user, due_date: 2.days.from_now, status: 1, priority: 2)

      # binding.pry

      get :highpriority

      expect(assigns(:tasks)).to eq([task1])
      expect(assigns(:tasks).current_page).to eq(1)
      expect(assigns(:tasks).limit_value).to eq(5)
    end
  end

  describe 'GET #show' do
    it "assigns  the requested task to @task" do 
      get :show, params: {id: task.id}
      expect(assigns(:task)).to eq(task)

    end

    it "renders the :show template" do
      get :show, params: { id: task.id }
      expect(response).to render_template(:show)
    end

  end

  describe "GET #new" do
    it "assigns a new task to @task" do
      get :new
      expect(assigns(:task)).to be_a_new(Task)
    end

    it "renders the :new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new task" do
        expect {
          post :create, params: { task: FactoryBot.attributes_for(:task) }
        }.to change(Task, :count).by(1)
      end

      it "redirects to the created task" do
        post :create, params: { task: FactoryBot.attributes_for(:task) }
        expect(response).to redirect_to(Task.last)
      end
    end

    context "with invalid params" do
      it "does not save the new task" do
        expect {
          post :create, params: { task: FactoryBot.attributes_for(:task, title: nil) }
        }.to_not change(Task, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { task: FactoryBot.attributes_for(:task, title: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST #edit" do
    it "edits task attributes" do
      post :edit, params: {id: task.id}
      expect(assigns(:task)).to_not be_a_new(Task)
    end
  end

  describe "Pose #update" do
    context "with valid parameters" do
      it "updates task attributes" do
        put :update, params: {id: task.id ,task: FactoryBot.attributes_for(:task, title: "this title is edited")}
        task.reload
        expect(task.title).to eq("this title is edited")
      end

      it "redirects to the updated task" do
        put :update, params: { id: task.id, task: FactoryBot.attributes_for(:task, title: "this title is edited") }
        expect(response).to redirect_to(task)
      end
    end
    
    context "with invalid parameters" do
      it "re-renders the edit template with unprocessable entity status" do
        put :update, params: { id: task.id, task: FactoryBot.attributes_for(:task, title: nil) }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end 