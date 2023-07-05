# frozen_string_literal: true

require 'factory_bot'

puts 'creating the first order...'
order1 = FactoryBot.create(:order, state: 'OPEN')
FactoryBot.create(:item, name: 'Tonno', size: 'Large', order_id: order1.id)

puts 'creating the 2nd order...'
order2 = FactoryBot.create(:order, state: 'OPEN')
FactoryBot.create(:item, name: 'Margherita', size: 'Large', add: %w[Onions Cheese Olives], order_id: order2.id)
FactoryBot.create(:item, name: 'Tonno', size: 'Medium', remove: %w[Onions Olives], order_id: order2.id)
FactoryBot.create(:item, name: 'Margherita', size: 'Small', order_id: order2.id)

puts 'creating the 3rd order...'
order3 = FactoryBot.create(:order, state: 'OPEN', promotion_codes: %w[2FOR1], discount_code: 'SAVE5')
FactoryBot.create(:item, name: 'Salami', size: 'Medium', add: %w[Onions], remove: %w[Cheese], order_id: order3.id)
FactoryBot.create_list(:item, 3, name: 'Salami', size: 'Small', order_id: order3.id)
FactoryBot.create(:item, name: 'Salami', size: 'Small', add: %w[Olives], order_id: order3.id)

puts 'calculating the total prices...'

[order1, order2, order3].each do |order|
  price = Services::PriceCalculation.new(order).call
  order.update(total_price: price)
end

puts 'DONE!'
