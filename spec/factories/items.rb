# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name { 'MyString' }
    size { 'MyString' }
    add { 'MyText' }
    remove { 'MyText' }
    order { nil }
  end
end
