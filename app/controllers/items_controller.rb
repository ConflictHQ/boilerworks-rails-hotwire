class ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy]

  def index
    authorize Item
    @pagy, @items = pagy(policy_scope(Item).order(created_at: :desc))
  end

  def show
    authorize @item
  end

  def new
    @item = Item.new
    authorize @item
    @categories = Category.order(:name)
  end

  def create
    @item = Item.new(item_params)
    authorize @item

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Item was successfully created." }
        format.turbo_stream
      else
        @categories = Category.order(:name)
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @item
    @categories = Category.order(:name)
  end

  def update
    authorize @item

    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: "Item was successfully updated." }
        format.turbo_stream
      else
        @categories = Category.order(:name)
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @item
    @item.soft_delete!

    respond_to do |format|
      format.html { redirect_to items_path, notice: "Item was successfully deleted." }
      format.turbo_stream
    end
  end

  private

  def set_item
    @item = Item.find_by!(uuid: params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :price, :slug, :category_id)
  end
end
