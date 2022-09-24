class PagesController < ApplicationController
  def home
    @klasses = Current.version.klasses
  end
end
