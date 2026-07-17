class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = current_group.categories
  end

  def new
    @category = current_group.categories.build
  end

  def create
    @category = current_group.categories.build(category_params)

    if @category.save
      redirect_to settings_path, notice: "カテゴリーを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit

  end

  def update
    if @category.update(category_params)
      redirect_to settings_path, notice: "カテゴリーを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to settings_path, notice: "カテゴリーを削除しました"
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
  
  def set_category
    @category = current_group.categories.find(params[:id])
  end

end
