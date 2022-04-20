# frozen_string_literal: true

require 'action_view/helpers/asset_url_helper'
require 'active_support/core_ext/hash/indifferent_access'

module MaterialDesignIcons
  class IconNotFoundError < RuntimeError
    def initialize(name)
      super("MaterialDesignIcons: Failed to find Material Design Icon: #{name}")
    end
  end

  class Icon
    include ActionView::Helpers::AssetUrlHelper

    attr_reader :name, :options, :path_options

    def initialize(name:, options: {}, path_options: {})
      @name = name
      @options = options
      @path_options = path_options
    end

    def render
      svg['data-material-design-icon-name'] = name

      add_path_options

      add_default_options

      doc
    end

    private

      def doc
        @doc ||= Nokogiri::HTML::DocumentFragment.parse(file)
      end

      def svg
        @svg ||= doc.at_css 'svg'
      end

      def add_path_options
        path_options.each do |key, value|
          attribute = key.to_s.dasherize

          svg.css("path[#{attribute}]").each do |item|
            item[attribute] = value.to_s
          end
        end
      end

      def add_default_options
        dasherize_attributes(options.reverse_merge(MaterialDesignIcons.configuration.default_options)).each do |key, value|
          svg[key] = value
        end
      end

      def file
        @file ||= file_path.read.force_encoding('UTF-8')
      rescue Errno::ENOENT
        raise IconNotFoundError, name
      end

      def file_path
        file_path = Rails.root.join("app/assets/images/material_design_icons/#{name}.svg")

        return file_path if file_path.exist?

        MaterialDesignIcons.root.join("app/assets/images/material_design_icons/#{name}.svg")
      end

      def flatten_attributes(attributes, collector = [], path_collector = [])
        attributes.each do |key, value|
          path_collector << key

          if value.is_a?(Hash)
            flatten_attributes(value, collector, path_collector)
          else
            collector << [*path_collector, value]
          end

          path_collector.pop
        end

        collector
      end

      def dasherize_attributes(attributes)
        flatten_attributes(attributes).each_with_object({}) do |attribute, memo|
          memo[attribute[0...-1].join('-').dasherize] = attribute.last
        end
      end

      class << self
        def render(**kwargs)
          new(**kwargs).render
        end
      end
  end
end
