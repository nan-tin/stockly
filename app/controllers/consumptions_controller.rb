class ConsumptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @month = params[:month].present? ? Date.parse("#{params[:month]}-01") : Date.current.beginning_of_month
    @display_month = @month.strftime("%Y年 %-m月")

    consumptions = current_group
                    .consumptions
                    .where(consumed_at: @month.beginning_of_month..@month.end_of_month)

    if params[:keyword].present?
      consumptions = consumptions.where("item_name ILIKE ?", "%#{params[:keyword]}%")
    end

    @consumption_summaries = consumptions
                              .group(:item_name, :category_name)
                              .select(
                                :item_name,
                                :category_name,
                                "SUM(quantity) AS total_quantity"
                              )

    @consumption_summaries =
      case params[:sort]
      when "quantity_desc"
        @consumption_summaries.order("total_quantity DESC")
      when "quantity_asc"
        @consumption_summaries.order("total_quantity ASC")
      when "name_asc"
        @consumption_summaries.order(:item_name)
      else
        @consumption_summaries.order("total_quantity DESC")
      end
  end
end
