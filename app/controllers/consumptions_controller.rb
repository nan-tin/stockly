class ConsumptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_consumption, only: %i[
    edit 
    update 
    destroy
    increase_quantity
    decrease_quantity
    ]

  def index
    @month = params[:month].present? ? Date.parse("#{params[:month]}-01") : Date.current.beginning_of_month
    @display_month = @month.strftime("%Y年 %-m月")
    @prev_month = @month.prev_month
    @next_month = @month.next_month
    @selected_date = params[:date].present? ? Date.parse(params[:date]) : Date.current

    start_date = @month.beginning_of_month.beginning_of_week(:sunday)

    end_date = @month.end_of_month.end_of_week(:sunday)

    @calendar_days = (start_date..end_date).to_a

    consumptions = current_group
                    .consumptions
                    .where(consumed_at: @month.beginning_of_month..@month.end_of_month)

    @consumption_counts_by_date = consumptions.group(:consumed_at).sum(:quantity)

    @selected_date_consumptions = current_group
                                    .consumptions
                                    .where(consumed_at: @selected_date)
    
    @selected_date_consumptions =
      case params[:sort]
      when "quantity_desc"
        @selected_date_consumptions.order(quantity: :desc)
      when "quantity_asc"
        @selected_date_consumptions.order(quantity: :asc)
      when "name_asc"
        @selected_date_consumptions.order(:item_name)
      else
        @selected_date_consumptions.order(created_at: :desc)
      end

    @daily_consumptions =
      consumptions.order(consumed_at: :desc)
                  .group_by(&:consumed_at)

    @holidays = HolidayJp.between(
      @month.beginning_of_month,
      @month.end_of_month
    ).map(&:date)

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

  def new 
    @consumption = current_group.consumptions.build(
      consumed_at: params[:date].presence || Date.current,
      quantity: 1
    )
  end

  def create
    @consumption = current_group.consumptions.build(consumption_params)

    category = current_group.categories.find_by(id: consumption_params[:category_id])

    if category.present?
      @consumption.category = category
      @consumption.category_name = category.name
    end

    if @consumption.save
      redirect_to consumptions_path(
        month: @consumption.consumed_at.strftime("%Y-%m"),
        date: @consumption.consumed_at.strftime("%Y-%m-%d")
      ), notice: "消費履歴を追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    category = current_group.categories.find_by(id: consumption_params[:category_id])

    if category.present?
      @consumption.category = category
      @consumption.category_name = category.name
    end

    if @consumption.update(consumption_params.except(:category_id))
      redirect_to consumptions_path(
        month: @consumption.consumed_at.strftime("%Y-%m"),
        date: @consumption.consumed_at.strftime("%Y-%m-%d")
      ), notice: "消費履歴を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    consumed_at = @consumption.consumed_at
    @consumption.destroy

    redirect_to consumptions_path(
      month: consumed_at.strftime("%Y-%m"),
      date: consumed_at.strftime("%Y-%m-%d")
    ), notice: "消費履歴を削除しました"
  end

  def increase_quantity
    @consumption.increment!(:quantity)

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to consumptions_path(
          month: @consumption.consumed_at.strftime("%Y-%m"),
          date: @consumption.consumed_at.strftime("%Y-%m-%d")
        )
      end
    end
  end

  def decrease_quantity
    @consumption.decrement!(:quantity) if @consumption.quantity > 1

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to consumptions_path(
          month: @consumption.consumed_at.strftime("%Y-%m"),
          date: @consumption.consumed_at.strftime("%Y-%m-%d")
        )
      end
    end
  end

  def summary_detail
    @month = params[:month].present? ? Date.parse("#{params[:month]}-01") : Date.current.beginning_of_month
    @display_month = @month.strftime("%Y年 %-m月")
    @item_name = params[:item_name]
    @category_name = params[:category_name]

    @consumptions = current_group
                      .consumptions
                      .where(consumed_at: @month.beginning_of_month..@month.end_of_month)
                      .where(item_name: @item_name, category_name: @category_name)
                      .order(consumed_at: :desc)

    @total_quantity = @consumptions.sum(:quantity)
  end     
  
  private

  def consumption_params
    params.require(:consumption).permit(
      :category_id,
      :item_name,
      :consumed_at,
      :quantity,
      :memo,
      :image
    )
  end

  def set_consumption
    @consumption = current_group.consumptions.find(params[:id])
  end
end
