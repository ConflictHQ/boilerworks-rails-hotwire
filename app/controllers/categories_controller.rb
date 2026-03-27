class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy]

  def index
    authorize Category
    @pagy, @categories = pagy(policy_scope(Category).order(created_at: :desc))
  end

  def show
    authorize @category
  end

  def new
    @category = Category.new
    authorize @category
    @parent_categories = Category.where(parent_id: nil).order(:name)
  end

  def create
    @category = Category.new(category_params)
    authorize @category

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: "Category was successfully created." }
        format.turbo_stream
      else
        @parent_categories = Category.where(parent_id: nil).order(:name)
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @category
    @parent_categories = Category.where(parent_id: nil).where.not(id: @category.id).order(:name)
  end

  def update
    authorize @category

    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: "Category was successfully updated." }
        format.turbo_stream
      else
        @parent_categories = Category.where(parent_id: nil).where.not(id: @category.id).order(:name)
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @category
    @category.soft_delete!

    respond_to do |format|
      format.html { redirect_to categories_path, notice: "Category was successfully deleted." }
      format.turbo_stream
    end
  end

  private

  def set_category
    @category = Category.find_by!(uuid: params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :slug, :description, :parent_id)
  end
end
