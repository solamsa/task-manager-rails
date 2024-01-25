module ControllerMacros
  def login_user
    before(:each) do 
      @request.env["devise.mapping"] = Devise.mapping[:user]
      user = FactoryBot.create(:user)
      sign_in user
    end
  end
end
