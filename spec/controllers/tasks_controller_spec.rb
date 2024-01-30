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

  describe 'POST #create' do
    it 'Task is valid' do
      expect(task).to be_valid
    end

    it 'checks that a task can be destroyed' do
      task 
      expect { delete :destroy, params: { id: task.id } }.to change(Task, :count).by(-1)
    end
  end

end 