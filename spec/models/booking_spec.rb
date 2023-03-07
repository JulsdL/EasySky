require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'booking instance' do
    before(:each) do
      user = User.new
      @booking = Booking.new(date: DateTime.now, street: 'rue de rennens', city: 'lausanne', zip: '1600', price: 1200,
                             status: :pending, user:)
    end
    context 'date' do
      it 'should check for the date to be present' do
        @booking.date = nil
        expect(@booking).not_to be_valid
      end
      it 'should only accept date format' do
        @booking.date = 'toto'
        expect(@booking).not_to be_valid
      end
    end
    context 'address' do
      it 'should check for the street to be present' do
        @booking.street = nil
        expect(@booking).not_to be_valid
      end
      it 'should check for the city to be present' do
        @booking.city = nil
        expect(@booking).not_to be_valid
      end
      it 'should check for the zip to be present' do
        @booking.zip = nil
        expect(@booking).not_to be_valid
      end
    end
    context 'user' do
      it 'should check for the user to be present' do
        @booking.user = nil
        expect(@booking).not_to be_valid
      end
    end
    context 'price' do
      it 'should check for the price to be present' do
        @booking.price = nil
        expect(@booking).not_to be_valid
      end
      it 'should accept only numerically values' do
        @booking.price = 'hello'
        expect(@booking).not_to be_valid
      end
      it 'should accept floating number' do
        @booking.price = 3.14
        expect(@booking).to be_valid
      end
    end
    context 'status' do
      it 'should check for the status to be present' do
        @booking.status = nil
        expect(@booking).not_to be_valid
      end
      it 'should validate that the status is confirmed, accepted or declined' do
        expect { @booking.status = 4 }.to raise_error(ArgumentError)
      end
      it 'should validate that the status is a number' do
        expect { @booking.status = :hello }.to raise_error(ArgumentError)
      end
    end
    context 'instance' do
      it 'should save if everything is good' do
        expect(@booking).to be_valid
      end
    end
  end
end
