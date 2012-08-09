require "httparty"

class DefaultController < ApplicationController
  before_filter :require_viewer

  def home
    if params[:venue_1] && params[:venue_2]
      @checkins = []
      @checkins << Checkin.at(viewer, params[:venue_1])
      @checkins << Checkin.at(viewer, params[:venue_2])
    end
    @checkins ||= Checkin.recent(viewer).reverse
    Rails.logger.debug(@checkins.to_yaml)
  end

  def test
    @venues = Checkin.venues(viewer)
  end
end
