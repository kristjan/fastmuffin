require "httparty"

class DefaultController < ApplicationController
  before_filter :require_viewer

  def home
    @checkins = Checkin.recent(viewer)
  end
end
