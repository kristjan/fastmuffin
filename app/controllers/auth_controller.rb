require "httparty"

class AuthController < ApplicationController

  def callback
    auth = request.env["omniauth.auth"]

    user = User.find_or_create_by_singly_id(auth.extra.id)
    user.update_attributes(:access_token => auth.credentials.token)

    session[:viewer_id]    = user.id
    session[:singly_id]    = user.singly_id
    session[:access_token] = user.access_token

    redirect_to root_path
  end

  def login
  end

  def logout
    session.clear
    redirect_to root_path
  end
end
