# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :size
      t.text :add
      t.text :remove
      t.references :order, type: :uuid, null: false, foreign_key: true
      t.timestamps
    end
  end
end
