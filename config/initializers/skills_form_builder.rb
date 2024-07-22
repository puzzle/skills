class SkillsFormBuilder < ActionView::Helpers::FormBuilder

  def cancel(value= nil, options = {})
    value, options = nil, value if value.is_a?(Hash)
    options[:class] ||= "btn btn-outline-secondary"
    options[:id] ||= "cancel-button"
    path ||= value || @template.polymorphic_path(self.object)
    button_text = options.delete(:text) || I18n.t('helpers.cancel')
    @template.link_to(button_text, path, options)
  end

  def label(method, text = nil, options = {}, &block)
    options[:class] ||= "form-label text-gray"
    super
  end

  def submit(value = nil, options = {})
    value, options = nil, value if value.is_a?(Hash)
    value ||= submit_default_value
    options[:class] ||= "btn btn-primary"
    @template.submit_tag(value, options)
  end
end
