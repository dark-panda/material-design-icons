# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MaterialDesignIcons::Icon do
  describe '.render' do
    it 'renders an icon' do
      expect(described_class.render(name: 'filled/check')).to have_mdi_icon('filled/check')
    end

    it 'renders an icon with :options' do
      expect(described_class.render(name: 'filled/check', options: { fill: 'currentColor' })).to have_selector('svg[fill="currentColor"]')
    end

    it 'renders an icon with :path_options' do
      expect(described_class.render(name: 'filled/check', path_options: { fill: 'currentColor' })).to have_selector('svg path[fill="currentColor"]')
    end

    it 'raises an exception on missing icons' do
      expect {
        described_class.render(name: 'nonsense')
      }.to raise_error(MaterialDesignIcons::IconNotFoundError)
    end

    it 'handles custom icons' do
      expect(described_class.render(name: 'simple/circle')).to have_mdi_icon('simple/circle')
    end

    it 'dasherizes data attributes' do
      expect(
        described_class.render(
          name: 'filled/content_copy',
          options: {
            data: {
              action: 'click',
              prefix__etc_target: 'target'
            }
          }
        )
      ).to have_selector('svg[data-action="click"][data-prefix--etc-target="target"]')
    end
  end
end
