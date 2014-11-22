class CategoriesController < ApplicationController
  before_action :require_user
  
  def index
    @categories = Category.includes(:videos).all
  end

  def show
    @category = Category.includes(:videos).find(params[:id])
  end
end
