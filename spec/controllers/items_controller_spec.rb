# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:order) { FactoryBot.create(:order) }
  let(:item) { FactoryBot.create(:item, order:) }

  before do
    allow(controller).to receive(:find_order).and_return(order)
  end

  describe '#new' do
    it 'instance variables for the items_config' do
      get :new,  params: { order_id: order.id }
      item_config = Rails.application.config.items
      expect(assigns(:pizzas)).to eq(item_config['pizzas'])
      expect(assigns(:ingredients)).to eq(item_config['ingredients'])
      expect(assigns(:size_multipliers)).to eq(item_config['size_multipliers'])
      expect(assigns(:item)).to be_a_new(Item)
    end

    it 'renders the new template' do
      get :new, params: { order_id: order.id }
      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    let(:valid_params) { { name: 'Margherita', size: 'Medium' } }
    context 'with valid parameters' do
      it 'creates a new item' do
        expect do
          post :create, params: { item: valid_params, order_id: order.id }
        end.to change(Item, :count).by(1)
      end

      it 'redirects to the edit order path' do
        post :create, params: { order_id: order.id, item: valid_params }
        expect(response).to redirect_to(edit_order_path(order))
      end
    end
  end
end
