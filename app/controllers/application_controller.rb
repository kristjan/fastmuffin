class ApplicationController < ActionController::Base

  protect_from_forgery

private

  def viewer
    return @viewer if @viewer

    if session[:viewer_id]
      @viewer = User.find_by_id(session[:viewer_id])
    end
  end
  helper_method :viewer

  def access_token
    viewer.access_token if viewer
  end
  helper_method :access_token

  def require_viewer
    redirect_to login_path unless viewer
  end
end
