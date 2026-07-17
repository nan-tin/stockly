class SettingsController < ApplicationController
  before_action :authenticate_user!
  
  def index
     @categories = current_group.categories.order(:created_at)
  end
end
