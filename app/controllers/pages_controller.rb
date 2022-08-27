class PagesController < ApplicationController
  def home
    @current_version = Version.first
    @klasses = @current_version.klasses
  end
end
