# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec::Matchers.define :have_mdi_icon do |icon, **options|
  attr_reader :icon

  match do |actual|
    return false if actual.blank?

    @icon = icon

    expect_doc_to_have_mdi_icon(**options)
    expect_icon_to_have_attributes

    true
  end

  failure_message do
    [
      "expected to have Material Design Icon '#{icon}'",
      value_description
    ].compact.join(' ')
  end

  failure_message_when_negated do
    [
      "expected not to have Material Design Icon '#{icon}'",
      value_description
    ].compact.join(' ')
  end

  description do
    [
      "have Material Design Icon '#{icon}'",
      value_description
    ].compact.join(' ')
  end

  def expect_doc_to_have_mdi_icon(**options)
    expect(doc).to have_selector("svg[data-material-design-icon-name='#{icon}']", **options)
  end

  def expect_icon_to_have_attributes
    expect(doc.at("svg[data-material-icon-name='#{icon}']").attributes).to match(hash_including(@attributes)) if defined?(@attributes)
  end

  def value_description
    return "with variant value #{matcher(@variant).description}" if defined?(@variant)

    "with value #{matcher(@value).description}" if defined?(@value)
  end

  def doc
    return @doc if defined?(@doc)

    @doc = if actual.respond_to?(:to_html)
      actual
    else
      Nokogiri::HTML(actual.to_s).css('body > *')
    end
  end

  def matcher(value)
    if value.is_a?(RSpec::Matchers::BuiltIn::BaseMatcher)
      value
    else
      eq(value)
    end
  end
end
# rubocop:enable Metrics/BlockLength
