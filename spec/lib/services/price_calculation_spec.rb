# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::PriceCalculation do
  let(:service) { described_class.new(order) }
  let(:items_config) do
    { 'size_multipliers' => { 'Small' => 0.5, 'Medium' => 1, 'Large' => 1.5 },
      'pizzas' => { 'Margherita' => 5, 'Salami' => 6, 'Tonno' => 8 },
      'ingredients' => { 'Onions' => 1, 'Cheese' => 2, 'Olives' => 2.5 },
      'promotions' => { '2FOR1' => { 'target' => 'Salami', 'target_size' => 'Small', 'from' => 2, 'to' => 1 },
                        '5FOR3' => { 'target' => 'Margherita', 'target_size' => 'Small', 'from' => 5, 'to' => 3 } },
      'discounts' => { 'SAVE5' => { 'deduction_in_percent' => 5 } } }
  end

  describe '#call' do
    before do
      allow(service).to receive(:items_config).and_return(items_config)
    end
    context 'when there are no promotions or discounts' do
      let(:order) { FactoryBot.create(:order) }
      before do
        FactoryBot.create_list(:item, 2, name: 'Salami', size: 'Small', order_id: order.id)
      end
      it 'calculates the total price based on the items' do
        expect(service.call).to eq(6.0)
      end
    end

    context 'when there are extra ingredients' do
      let(:order) { FactoryBot.create(:order) }
      before do
        FactoryBot.create_list(:item, 2, name: 'Salami', size: 'Small', order_id: order.id)
        FactoryBot.create(:item, :with_olives_and_cheese, order_id: order.id)
      end
      let(:service) { described_class.new(order) }
      it 'calculates the total price of the items with the ingredients' do
        expect(service.call).to eq(13.5)
      end
    end

    context 'when there are applicable promotions and discounts' do
      let(:order) { FactoryBot.create(:order) }
      before do
        FactoryBot.create(:item, :with_olives_and_cheese, name: 'Salami', size: 'Small', order_id: order.id)
        FactoryBot.create(:item, name: 'Salami', size: 'Small', order_id: order.id)
      end
      it 'calculates the total price with promotion code' do
        order.promotion_codes = ['2FOR1']
        expect(service.call).to eq(7.50)
      end

      it 'calculates the total price with promotion and discount codes' do
        order.promotion_codes = ['2FOR1']
        order.discount_code = 'SAVE5'
        expect(service.call).to eq(7.125)
      end
    end

    context 'when there is a 5FOR3 promotion' do
      let(:order) { FactoryBot.create(:order) }
      before do
        FactoryBot.create_list(:item, 5, name: 'Margherita', size: 'Small', order_id: order.id)
      end
      it 'calculates the total price with promotion code' do
        order.promotion_codes = ['5FOR3']
        expect(service.call).to eq(7.5)
      end
    end

    context 'when there is a 2FOR1 promotions' do
      let(:order) { FactoryBot.create(:order) }
      before do
        FactoryBot.create_list(:item, 2, name: 'Salami', size: 'Small', order_id: order.id)
      end
      it 'applies the promotion code more than once' do
        order.promotion_codes = ['2FOR1']
        expect(service.call).to eq(3)
      end
    end

    context 'when there are multiple promotion codes' do
      let(:order) { FactoryBot.create(:order) }
      before do
        FactoryBot.create_list(:item, 5, name: 'Margherita', size: 'Small', order_id: order.id)
        FactoryBot.create_list(:item, 2, name: 'Salami', size: 'Small', order_id: order.id)
      end
      it 'applies the promotion code more than once' do
        order.promotion_codes = %w[2FOR1 5FOR3]
        expect(service.call).to eq(10.5)
      end
    end
  end
end
