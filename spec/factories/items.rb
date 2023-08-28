# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name { 'Salami' }
    size { 'Small' }
    add { [] }
    remove { [] }

    trait :with_olives_and_cheese do
      add { %w[Olives Cheese] }
      remove { %w[Onions] }
    end
  end
end
