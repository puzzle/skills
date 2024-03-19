# frozen_string_literal: true

module TextHelper
  def simple_format(text, html_options = {}, options = {})
    wrapper_tag = options.fetch(:wrapper_tag, :p)

    text = sanitize(text) if options.fetch(:sanitize, true)
    paragraphs = split_paragraphs(text)

    if paragraphs.empty?
      content_tag(wrapper_tag, nil, html_options)
    else
      paragraphs.map! { |paragraph|
        content_tag(wrapper_tag, raw(paragraph), html_options)
      }.join("\n\n").html_safe
    end
  end
end