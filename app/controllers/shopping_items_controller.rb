class ShoppingItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shopping_item, only: %i[edit update destroy]

  def index
    @shopping_items = current_group
                        .shopping_list
                        .shopping_items
                        .includes(:category)
  end

  def new
    @shopping_item = current_group.shopping_list.shopping_items.build
  end

  def create
    @shopping_item = current_group.shopping_list.shopping_items.build(shopping_item_params)

    if @shopping_item.save
      redirect_to shopping_items_path, notice: "買うものを追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @shopping_item.update(shopping_item_params)
      redirect_to shopping_items_path, notice: "買うものを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shopping_item.destroy
    redirect_to shopping_items_path, notice: "買うものを削除しました"
  end

  private

  def shopping_item_params
    params.require(:shopping_item).permit(
      :category_id,
      :name,
      :quantity,
      :memo
    )
  end

  def set_shopping_item
    @shopping_item = current_group.shopping_list.shopping_items.find(params[:id])
  end
  
end
