class ApplicationController < ActionController::Base
  private

  def current_group
    current_user.groups.first
  end

  helper_method :current_group
end
