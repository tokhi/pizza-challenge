# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe '#index' do
    it 'assigns the orders with open state' do
      open_orders = FactoryBot.create_list(:order, 2, state: 'OPEN')
      FactoryBot.create(:order, state: 'COMPLETE')

      get :index

      expect(assigns(:orders)).to match_array(open_orders)
    end
  end

  describe '#show' do
    let(:order) { FactoryBot.create(:order) }

    it 'assigns the requested order' do
      get :show, params: { id: order.id }
      expect(assigns(:order)).to eq(order)
    end
  end

  describe '#new' do
    it 'creates a new order' do
      get :new
      order = assigns(:order)

      expect(order.state).to eq('OPEN')
    end

    it 'redirects to the edit order path' do
      get :new
      order = assigns(:order)

      expect(response).to redirect_to(edit_order_path(order))
    end
  end

  describe '#create' do
    let(:order_params) { { state: 'OPEN' } }

    context 'with valid params' do
      it 'creates a new order' do
        expect do
          post :create, params: { order: order_params }
        end.to change(Order, :count).by(1)
      end
    end
  end

  describe '#update' do
    let(:order) { FactoryBot.create(:order) }
    let(:order_params) { { state: 'COMPLETE' } }

    context 'with valid params' do
      it 'updates the requested order' do
        patch :update, params: { id: order.id, order: order_params }
        order.reload

        expect(order.state).to eq('COMPLETE')
      end

      it 'redirects to the orders index' do
        patch :update, params: { id: order.id, order: order_params }

        expect(response).to redirect_to('/orders')
      end
    end
  end

  describe '#destroy' do
    let!(:order) { FactoryBot.create(:order) }

    it 'destroys the requested order' do
      expect do
        delete :destroy, params: { id: order.id }
      end.to change(Order, :count).by(-1)
    end

    it 'redirects to the orders index' do
      delete :destroy, params: { id: order.id }
      expect(response).to redirect_to(orders_url)
    end
  end

  describe 'set order total price' do
    let(:order) { FactoryBot.create(:order) }
    let(:total_price) { 25.2 }
    before do
      allow_any_instance_of(Services::PriceCalculation).to receive(:call).and_return(total_price)
    end

    it 'sets the total price after update action' do
      expect do
        patch :update, params: { id: order.id, order: { discount_code: 'code' } }
      end.to(change { order.reload.total_price })
    end
  end
end
