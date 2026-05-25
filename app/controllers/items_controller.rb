class ItemsController < ApplicationController
  before_action :authenticate_user!

  #includes は「N+1問題」を防ぐためのメソッド
  def index
    @items = current_group.items.includes(:category)
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

end
