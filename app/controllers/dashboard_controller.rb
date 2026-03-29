class DashboardController < ApplicationController
  def index
    @items_count = Item.count
    @categories_count = Category.count
    @users_count = User.count
  end
end
