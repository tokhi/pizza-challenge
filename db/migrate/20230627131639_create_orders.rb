# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders, id: :string do |t|
      t.string :state
      t.text :promotion_codes
      t.string :discount_code
      t.decimal :total_price, precision: 10, scale: 2
      t.timestamps
    end
    add_index :orders, :id, unique: true
  end
end
