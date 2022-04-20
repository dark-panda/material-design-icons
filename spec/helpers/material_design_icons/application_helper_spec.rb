# frozen_string_literal: true

require 'spec_helper'
require 'material_design_icons/application_helper'
require 'action_view/helpers/output_safety_helper'

RSpec.describe MaterialDesignIcons::ApplicationHelper do
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::TagHelper
  include described_class

  describe '.render' do
    it 'renders an icon' do
      expect(mdi_icon('filled/check')).to have_mdi_icon('filled/check')
    end

    it 'renders an icon with :options' do
      expect(mdi_icon('filled/check', options: { fill: 'currentColor' })).to have_selector('svg[fill="currentColor"]')
    end

    it 'renders an icon with :path_options' do
      expect(mdi_icon('filled/check', path_options: { fill: 'currentColor' })).to have_selector('svg path[fill="currentColor"]')
    end

    it 'renders a JavaScript console alert for missing icons' do
      expect(mdi_icon('nonsense')).to have_selector('script', visible: :hidden, text: 'console.warn("MaterialDesignIcons: Failed to find MaterialDesignIcons: nonsense")')
    end

    it 'handles custom icons' do
      expect(mdi_icon('simple/circle')).to have_mdi_icon('simple/circle')
    end

    it 'dasherizes data attributes' do
      expect(
        mdi_icon(
          'filled/content_copy',
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
