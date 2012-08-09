class CheckinsController < ApplicationController
  before_filter :require_viewer

  def sync
    Checkin.sync(viewer)
    last_checkin = Checkin.last(viewer)

    flash[:notice] = last_checkin ?
       "Last checkin was at #{last_checkin.venue_name}." :
       "No checkins."

    redirect_to root_path
  end
end
