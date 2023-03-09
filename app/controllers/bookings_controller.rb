class BookingsController < ApplicationController
  before_action :set_items, only: %i[new create]
  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @booking.status = :pending
    if @booking.save
      redirect_to checkout_booking_path(@booking)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def checkout
    @booking = Booking.find(params[:id])
  end

  private

  def booking_params
    params.require(:booking).permit(:date, :street, :city, :zip, item_ids: [])
  end

  def set_items
    @items = Item.all
  end
end
