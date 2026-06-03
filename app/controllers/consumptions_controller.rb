class ConsumptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @consumptions = current_group
                      .consumptions
                      .order(consumed_at: :desc)

  end
end
