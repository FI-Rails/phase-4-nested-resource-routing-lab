class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
# rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  def index
    if params[:user_id]
      items = User.find(params[:user_id]).items 
    else 
      items = Item.all
    end
    render json: items, include: :user
  end

  def show 
    item = Item.find(params[:id])
    render json: item, include: :user
  end

  def create 
    user = User.find(params[:user_id])
    item = Item.create(item_params)
    # user.items << Item.create(item_params) 
    user.items << item
    render json: item, status: :created
  end

  # def create
  #   user = find_user
  #   item = user.items.create(item_params)
  #   render json: item, status: :created
  # end
  # def find_user
  #   User.find(params[:user_id])
  # end

  private 
  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

  def render_not_found 
    render json: {error: "not found"}, status: :not_found
  end

end
