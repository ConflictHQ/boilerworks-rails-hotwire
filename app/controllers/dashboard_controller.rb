class DashboardController < ApplicationController
  def index
    @products_count = Product.count
    @categories_count = Category.count
    @users_count = User.count
  end
end
