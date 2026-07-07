class ShoppingItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shopping_item, 
                only: %i[edit update destroy increase_quantity decrease_quantity]

  def index
    @shopping_items = current_group
                        .shopping_list
                        .shopping_items
                        .where(is_purchased: false)
                        .order(:created_at, :id)
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

  def bulk_purchase
    shopping_items = current_group
                      .shopping_list
                      .shopping_items
                      .where(id: params[:shopping_item_ids])

    if shopping_items.blank?
      redirect_to shopping_items_path,
                  alert: "購入済みにするアイテムを選択してください"
      return
    end

    ActiveRecord::Base.transaction do
      shopping_items.each do |shopping_item|
        item = current_group.items.find_or_initialize_by(
          category: shopping_item.category,
          name: shopping_item.name,
          memo: shopping_item.memo
        )

        item.quantity ||= 0
        item.quantity += shopping_item.quantity
        item.purchased_at = Date.current
        item.memo = shopping_item.memo if item.memo.blank?

        item.save!
        shopping_item.destroy!
      end
    end

    redirect_to shopping_items_path,
                notice: "選択した買うものを在庫へ追加しました"
  end
  
  def bulk_destroy
    shopping_items = current_group
                      .shopping_list
                      .shopping_items
                      .where(id: params[:shopping_item_ids])

    if shopping_items.blank?
      redirect_to shopping_items_path,
                  alert: "削除する買うものを選択してください"
      return
    end

    shopping_items.destroy_all

    redirect_to shopping_items_path,
                notice: "選択した買うものを削除しました"
  end  

  def purchase
    shopping_item = current_group
                      .shopping_list
                      .shopping_items
                      .find(params[:id])

    ActiveRecord::Base.transaction do
      item = current_group.items.find_or_initialize_by(
        category: shopping_item.category,
        name: shopping_item.name,
        memo: shopping_item.memo
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

  def increase_quantity
    @shopping_item.increment!(:quantity)

    redirect_to shopping_items_path
  end

  def decrease_quantity
    @shopping_item.decrement!(:quantity) if @shopping_item.quantity > 1

    redirect_to shopping_items_path
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
