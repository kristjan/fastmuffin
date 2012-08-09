require "httparty"

class DefaultController < ApplicationController
  before_filter :require_viewer

  def home
  end
end
