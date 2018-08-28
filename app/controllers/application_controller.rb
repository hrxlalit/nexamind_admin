class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  def render_message code,message
    render :json => {:responseCode => code,:responseMessage => message}
  end
    
  def is_json?
    if request.format != :json
      render :json => {
        :responseCode => 400,
        :responseMessage => "The request must be json."
      }
    end
  end

  
end
