class ApplicationController < ActionController::Base
  helper_method :current_group

  protected

  def after_sign_out_path_for(_resource_or_scope)
    login_path
  end

  private

  def current_group
    current_user.groups.first
  end
end