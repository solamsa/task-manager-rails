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
  end

  it "should have a current_user" do
    # note the fact that you should remove the "validate_session" parameter if this was a scaffold-generated controller
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