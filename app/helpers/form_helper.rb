# Defines forms to edit models. The helper methods come in different
# granularities:
# * #plain_form - A form using Crud::FormBuilder.
# * #standard_form - A #plain_form for a given object and attributes with error
#   messages and save and cancel buttons.
# * #crud_form - A #standard_form for the current +entry+, with the given
#   attributes or default.
module FormHelper

  # Renders a form using Crud::FormBuilder.
  def plain_form(object, options = {}, &)
    options[:html] ||= {}
    add_css_class(options[:html], 'form-horizontal')
    options[:html][:role] ||= 'form'
    options[:builder] ||= DryCrud::Form::Builder
    options[:cancel_url] ||= polymorphic_path(object, returning: true)

    form_for(object, options, &)
  end

  # Renders a standard form for the given entry and attributes.
  # The form is rendered with a basic save and cancel button.
  # If a block is given, custom input fields may be rendered and attrs is
  # ignored. Before the input fields, the error messages are rendered,
  # if present. An options hash may be given as the last argument.
  def standard_form(object, *attrs, &)
    plain_form(object, attrs.extract_options!) do |form|
      content = [form.error_messages]

      content << if block_given?
                   capture(form, &)
                 else
                   form.labeled_input_fields(*attrs)
                 end

      content << form.standard_actions
      safe_join(content)
    end
  end

  # Renders a crud form for the current entry with default_crud_attrs or the
  # given attribute array. An options hash may be given as the last argument.
  # If a block is given, a custom form may be rendered and attrs is ignored.
  def crud_form(*attrs, &)
    options = attrs.extract_options!
    attrs = default_crud_attrs - %i[created_at updated_at] if attrs.blank?
    attrs << options
    standard_form(path_args(entry), *attrs, &)
  end

  def disabled_with_ptime_sync
    if use_ptime_sync?
      {
        'data-bs-toggle': 'tooltip',
        'data-bs-title': I18n.t('people.form.ptime_data'),
        'data-bs-placement': 'top',
        'data-controller': 'tooltip',
        disabled: true
      }
    end
  end
end
