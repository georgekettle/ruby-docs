class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @klasses = Current.version.klasses
  end
end
