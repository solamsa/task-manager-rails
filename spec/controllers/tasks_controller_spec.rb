require "rails_helper"

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) } # Assuming you have a user factory defined

  before do
    sign_in user
  end

  it "should have a current_user" do
    # note the fact that you should remove the "validate_session" parameter if this was a scaffold-generated controller
    expect(subject.current_user).to_not eq(nil)
  end

  it "should have a current_user" do
    get :index
    expect(controller.current_user).to eq(user)
  end

  it "should return 200:OK" do
    get :index
    expect(response).to have_http_status(:success)
  end

end 