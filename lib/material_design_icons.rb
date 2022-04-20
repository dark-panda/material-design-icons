# frozen_string_literal: true

require 'material_design_icons/engine'
require 'material_design_icons/icon'
require 'material_design_icons/configuration'

module MaterialDesignIcons
  def self.root
    Pathname.new("#{__dir__}/..")
  end

  autoload :Matchers, root.join('lib/material_design_icons/matchers')
end
