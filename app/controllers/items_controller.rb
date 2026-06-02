class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: %i[edit update destroy]

  #includes は「N+1問題」を防ぐためのメソッド
  def index
    @items = current_group
                .items
                .includes(:category, image_attachment: :blob)
    if params[:keyword].present?
      @items = @items.where("items.name ILIKE ?", "%#{params[:keyword]}%")
    end

    case params[:sort]
    when "purchased_desc"
      @items = @items.order(purchased_at: :desc)
    when "purchased_asc"
      @items = @items.order(purchased_at: :asc)
    when "quantity_desc"
      @items = @items.order(quantity: :desc)
    when "quantity_asc"
      @items = @items.order(quantity: :asc)
    when "name_asc"
      @items = @items.order(name: :asc)
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = current_group.items.build(item_params)

    if @item.save
      redirect_to items_path, notice: "アイテムを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to items_path, notice: "アイテムを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: "アイテムを削除しました"
  end

  def bulk_destroy
    current_group.items.where(id: params[:item_ids]).destroy_all

    redirect_to items_path, notice: "選択したアイテムを削除しました"
  end

  def consume 
    item = current_group.items.find(params[:id])

    ActiveRecord::Base.transaction do
      current_group.consumptions.create!(
        category: item.category,
        category_name: item.category.name,
        item_name: item.name,
        quantity: item.quantity,
        consumed_at: Date.current,
        memo: item.memo
      )

      item.destroy!
    end

    redirect_to items_path, notice: "消費履歴を登録しました"
  end

  private

  def item_params
    params.require(:item).permit(
      :category_id,
      :name,
      :quantity,
      :purchased_at,
      :expired_at,
      :memo,
      :image
    )
  end

  def set_item
    @item = current_group.items.find(params[:id])
  end

end
