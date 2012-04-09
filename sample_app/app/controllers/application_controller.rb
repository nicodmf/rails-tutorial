class ApplicationController < ActionController::Base
  protect_from_forgery
  #session :off
  include SessionsHelper
end
