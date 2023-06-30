# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    id { SecureRandom.uuid }
    state { 'open' }
  end
end
