class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def rescue_stripe_errors(e)
    body = e.json_body rescue e
    err  = body[:error][:message] rescue e.message
    flash[:error] = err
  end
end
