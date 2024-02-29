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

      context "with status parameter" do
        it "returns tasks matching the query query" do
          task_with_status = create(:task, user: user, title: "SearchTermTask", description:"this is a search test description", status: 0)
  
          get :index, params: { status: 0 }
  
          expect(assigns(:tasks)).to include(task_with_status)
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
        expect(response).to redirect_to(tasks_path)
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
        expect(response).to redirect_to(tasks_path)
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