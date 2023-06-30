# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :set_order

  def index
    @items = Item.all
  end

  def show; end

  def new
    item_config = Rails.application.config.items
    @pizzas = item_config['pizzas']
    @ingredients = item_config['ingredients']
    @size_multipliers = item_config['size_multipliers']
    @item = @order.items.new
  end

  # GET /items/1/edit
  def edit; end

  # POST /items or /items.json
  def create
    @item = @order.items.create!(item_params)

    respond_to do |format|
      format.html { redirect_to edit_order_path(@order) }
    end
  end

  private

  def set_order
    @order = Order.find params[:order_id]
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:name, :size, :order_id, add: [], remove: [])
  end
end
