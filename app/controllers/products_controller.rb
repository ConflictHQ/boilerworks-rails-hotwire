class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    authorize Product
    @pagy, @products = pagy(policy_scope(Product).order(created_at: :desc))
  end

  def show
    authorize @product
  end

  def new
    @product = Product.new
    authorize @product
    @categories = Category.order(:name)
  end

  def create
    @product = Product.new(product_params)
    authorize @product

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.turbo_stream
      else
        @categories = Category.order(:name)
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @product
    @categories = Category.order(:name)
  end

  def update
    authorize @product

    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.turbo_stream
      else
        @categories = Category.order(:name)
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @product
    @product.soft_delete!

    respond_to do |format|
      format.html { redirect_to products_path, notice: "Product was successfully deleted." }
      format.turbo_stream
    end
  end

  private

  def set_product
    @product = Product.find_by!(uuid: params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :slug, :category_id)
  end
end
