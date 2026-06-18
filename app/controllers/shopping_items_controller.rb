class ShoppingItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shopping_item, only: %i[edit update destroy]

  def index
    @shopping_items = current_group
                        .shopping_list
                        .shopping_items
                        .includes(:category)
                        .where(is_purchased: false)
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

  def purchase
    shopping_item = current_group
                      .shopping_list
                      .shopping_items
                      .find(params[:id])

    ActiveRecord::Base.transaction do
      item = current_group.items.find_or_initialize_by(
        category: shopping_item.category,
        name: shopping_item.name
      )

      item.quantity ||= 0
      item.quantity += shopping_item.quantity
      item.purchased_at = Date.current
      item.memo = shopping_item.memo if item.memo.blank?

      item.save!

      shopping_item.destroy!
    end

    redirect_to shopping_items_path,
                notice: "在庫へ追加しました"
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
