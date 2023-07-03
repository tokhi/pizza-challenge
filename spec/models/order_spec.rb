# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'scopes' do
    context 'with open_state' do
      let!(:open_order) { FactoryBot.create(:order, state: 'OPEN') }
      let!(:complete_order) { FactoryBot.create(:order, state: 'COMPLETE') }

      it 'returns orders with state "OPEN"' do
        expect(Order.with_open_state).to contain_exactly(open_order)
      end
    end
  end

  describe 'callbacks' do
    context 'set_uuid before create' do
      let(:order) { FactoryBot.build(:order, id: nil) }

      it 'sets UUID for the order' do
        expect { order.save }.to change(order, :id).from(nil).to(String)
      end

      it 'does not change UUID if already set' do
        order.id = 'uuid'
        expect { order.save }.not_to change(order, :id)
      end
    end
  end
end
