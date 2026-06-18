class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: %i[edit update destroy add_to_shopping_item]

  #includes は「N+1問題」を防ぐためのメソッド
  def index
    @categories = current_group.categories.order(:name)
    @selected_category_id = params[:category_id]
    @display = params[:display].presence || "quantity"

    @items = current_group
              .items

    if @selected_category_id.present?
      @items = @items.where(category_id: @selected_category_id)
    end

    if params[:keyword].present?
      @items = @items.where("items.name ILIKE ?", "%#{params[:keyword]}%")
    end

    if params[:category_id].present?
      @items = @items.where(category_id: params[:category_id])
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
    else
      @items = @items.order(created_at: :desc)
    end

    @shopping_item_quantities = current_group
                              .shopping_list
                              .shopping_items
                              .where(is_purchased: false)
                              .group(:category_id, :name)
                              .sum(:quantity)
  end

  def new
    @item = Item.new
  end

  def create
    existing_item = current_group.items.find_by(
      category_id: item_params[:category_id],
      name: item_params[:name]
    )

    if existing_item
      existing_item.quantity += item_params[:quantity].to_i
      existing_item.purchased_at = item_params[:purchased_at] if item_params[:purchased_at].present?
      existing_item.expired_at = item_params[:expired_at] if item_params[:expired_at].present?
      existing_item.memo = item_params[:memo] if item_params[:memo].present?

      if existing_item.save
        redirect_to items_path, notice: "既存アイテムの在庫数を更新しました"
      else
        @item = existing_item
        render :new, status: :unprocessable_entity
      end
    else
      @item = current_group.items.build(item_params)

      if @item.save
        redirect_to items_path, notice: "アイテムを作成しました"
      else
        render :new, status: :unprocessable_entity
      end
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
    if params[:item_ids].blank?
      redirect_to items_path, alert: "削除するアイテムを選択してください"
      return
    end

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

  def add_to_shopping_item
    shopping_item = current_group
                      .shopping_list
                      .shopping_items
                      .find_or_initialize_by(
                        category: @item.category,
                        name: @item.name,
                        is_purchased: false
                      )

    if shopping_item.new_record?
      shopping_item.quantity = 1
      shopping_item.memo = @item.memo
    else
      shopping_item.quantity += 1
    end

    shopping_item.save!

    redirect_to items_path(
      category_id: params[:category_id],
      display: params[:display],
      sort: params[:sort]
    ), notice: "買う物に追加しました"
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
