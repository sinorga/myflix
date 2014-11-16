class CategoriesController < ApplicationController
  def index
    @categories = Category.includes(:videos).all
  end

  def show
    @category = Category.includes(:videos).find(params[:id])
  end
end
