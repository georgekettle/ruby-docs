module Versionable
  extend ActiveSupport::Concern

  included do
    before_action :set_current_version
  end

  def set_current_version
    v_num = params[:version_number] || session[:version_number]
    Current.version = Version.find_by(number: v_num) || Version.first
    session[:version_number] = Current.version.number
  end
end