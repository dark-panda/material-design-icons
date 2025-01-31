# frozen_string_literal: true

module MaterialDesignIcons
  module ApplicationHelper
    class HelperSingleton
      include Singleton
      include ActionView::Helpers::JavaScriptHelper
      include ActionView::Helpers::TagHelper
    end

    def mdi_icon(name, options: {}, path_options: {})
      MaterialDesignIcons::Icon.render(
        name: name,
        options: options,
        path_options: path_options
      ).to_s.html_safe
    rescue MaterialDesignIcons::IconNotFoundError
      return if Rails.env.production?

      HelperSingleton.instance.javascript_tag(%{console.warn("MaterialDesignIcons: Failed to find MaterialDesignIcons: #{name}")})
    end
  end
end
