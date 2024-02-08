class Users::RegistrationsController < Devise::RegistrationsController
  # Your custom actions or overrides

  def show 
    @user = current_user
  end
end