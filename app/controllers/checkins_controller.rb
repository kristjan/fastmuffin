class CheckinsController < ApplicationController
  before_filter :require_viewer

  def sync
    Checkin.sync(viewer)
    flash[:notice] = "Checkins synched"
    redirect_to root_path
  end
end
