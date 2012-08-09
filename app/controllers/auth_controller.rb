require "httparty"

class AuthController < ApplicationController

  SINGLY_API_BASE = "https://api.singly.com"

  def callback
    auth = request.env["omniauth.auth"]

    user = User.find_or_create_by_singly_id(auth.extra.id)
    user.update_attributes(:access_token => auth.credentials.token)

    session[:viewer_id]    = user.id
    session[:singly_id]    = user.singly_id
    session[:access_token] = user.access_token

    redirect_to "/"
  end

  def logout
    session.clear
    redirect_to "/"
  end
end
