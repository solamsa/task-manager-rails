require "rails_helper"

#To do test that after 5 tasks kaminary will be active
RSpec.describe "User signs in", type: :system do
  before do
    @user = create :user
    visit new_user_session_path
  end
  scenario "valid with correct credentials" do
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password
    click_button "Log in"
    expect(page).to have_text "Task Manager"
    expect(page).to have_text "Tasks"
  end 

end