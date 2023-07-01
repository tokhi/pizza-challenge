# frozen_string_literal: true

module Services
  class PriceCalculation
    def initialize(order)
      @order = order
    end

    def call
      items = @order.items

      total_price = calculate_items_total_price(items)
      total_price -= apply_promotions(items) if apply_promotions?(items)
      total_price -= apply_discount(total_price) if discount_applicable?

      total_price
    end

    def calculate_item_price(name, size, ingredients)
      base_price = items_config['pizzas'][name]
      multiplier = items_config['size_multipliers'][size]
      ingredient_price = ingredients.sum { |ingredient| items_config['ingredients'][ingredient] || 0 }

      (base_price * multiplier) + ingredient_price
    end

    def calculate_items_total_price(items)
      items.sum { |item| calculate_item_price(item.name, item.size, item.add) }
    end

    def apply_promotions?(items)
      promotion_codes = @order.promotion_codes.compact_blank
      promotion_codes.any? { |promotion_code| promotion_applicable?(items, promotion_code) }
    end

    def apply_promotions(items)
      promotion_codes = @order.promotion_codes.compact_blank
      total_discount = 0

      items_hash = items.group_by { |item| [item.name, item.size] }

      promotion_codes.each do |promotion_code|
        promotion = items_config['promotions'][promotion_code]
        next unless promotion

        matching_items = items_hash.select do |key, _|
          item_name, item_size = key
          item_name == promotion['target'] || item_size == promotion['target_size']
        end

        next if matching_items.empty?

        total_discount += calculate_promotion_discount(matching_items, promotion)
      end

      total_discount
    end

    def calculate_promotion_discount(matching_items, promotion)
      total_discount = 0

      matching_items.each do |_, matching_items_array|
        quantity = matching_items_array.size
        next unless quantity >= promotion['from']

        matching_item = matching_items_array.first
        discount = (quantity / promotion['from']) * promotion['to'] * calculate_item_price(
          matching_item.name, matching_item.size, []
        )
        total_discount += discount
      end

      total_discount
    end

    def promotion_applicable?(items, promotion_code)
      promotion = items_config['promotions'][promotion_code]
      return false unless promotion

      items.any? { |item| item.name == promotion['target'] || item.size == promotion['target_size'] }
    end

    def discount_applicable?
      @order.discount_code.present? and items_config['discounts'][@order.discount_code]
    end

    def apply_discount(total_price)
      discount_percent = items_config['discounts'][@order.discount_code]['deduction_in_percent']
      return total_price unless discount_percent.present?

      (total_price * discount_percent) / 100
    end

    def items_config
      @items_config ||= Rails.application.config.items
    end
  end
end
