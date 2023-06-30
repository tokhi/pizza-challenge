# frozen_string_literal: true

class Order < ApplicationRecord
  before_create :set_uuid

  has_many :items

  serialize :promotion_codes, Array

  scope :with_open_state, -> { where(state: 'OPEN') }

  def set_uuid
    self.id = SecureRandom.uuid if id.blank?
  end
end
