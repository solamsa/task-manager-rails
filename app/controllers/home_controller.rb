class HomeController < ApplicationController
  # Your actions go here
  before_action :authenticate_user!
  def index
    # Your code for the index action goes here
  end
end