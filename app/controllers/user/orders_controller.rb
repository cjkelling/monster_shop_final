# frozen_string_literal: true

class User::OrdersController < ApplicationController
  before_action :exclude_admin

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.new
    order.save
    cart.items.each do |item|
      order.order_items.create(
        item: item,
        quantity: cart.count_of(item.id),
        price: item.price
      )
    end
    session.delete(:cart)
    if current_coupon
      redirect_to "/coupon/users/#{order.id}"
    else
      flash[:notice] = 'Order created successfully!'
      redirect_to '/profile/orders'
    end
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to "/profile/orders/#{order.id}"
  end
end
