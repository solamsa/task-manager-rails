require_relative './controller_macros'

RSpec.configure do |cofig|
  
  config.include Devise::Test::ControllerHelpers, :type => :controller

  config.extend ControllerMacros, :type => :controller
end