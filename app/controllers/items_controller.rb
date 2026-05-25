class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: %i[edit update destroy]

  #includes は「N+1問題」を防ぐためのメソッド
  def index
    @items = current_group.items.includes(:category).with_attached_image
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
