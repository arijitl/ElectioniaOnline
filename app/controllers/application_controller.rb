class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  before_filter :default_headers


  rescue_from CanCan::AccessDenied do |exception|
    redirect_to "/", :alert => exception.message
  end





  def default_headers
    headers['X-Frame-Options'] = 'SAMEORIGIN'
  end


end
