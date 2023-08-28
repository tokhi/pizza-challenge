# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def item_config
    @item_config ||= Rails.application.config.items
  end
end
