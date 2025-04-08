# Helpers to create action links. This default implementation supports
# regular links with an icon and a label. To change the general style
# of action links, change the method #action_link, e.g. to generate a button.
# The common crud actions show, edit, destroy, index and add are provided here.
module ActionsHelper

  # A generic helper method to create action links.
  # These link could be styled to look like buttons, for example.
  def action_link(label, icon = nil, url = {}, options = {})
    add_css_class options, 'action btn btn-link d-flex align-items-center gap-2'
    link_to(icon ? action_icon(icon, label) : label,
            url, options)
  end

  # Outputs an icon for an action with an optional label.
  def action_icon(icon, label = nil)
    html = content_tag(:span, '', class: "icon icon-#{icon}")
    html << ' ' << label if label
    html
  end

  # Standard show action to the given path.
  # Uses the current +entry+ if no path is given.
  def show_action_link(path = nil)
    path ||= path_args(entry)
    action_link(ti('link.show'), 'zoom-in', path)
  end

  # Standard edit action to given path.
  # Uses the current +entry+ if no path is given.
  def edit_action_link(path = nil, options: {})
    path ||= path_args(entry)
    path = edit_polymorphic_path(path) unless path.is_a?(String)
    action_link(ti('link.edit'), 'pencil', path, options)
  end

  # Standard destroy action to the given path.
  # Uses the current +entry+ if no path is given.
  def destroy_action_link(path = nil, icon = 'remove')
    path ||= path_args(entry)
    action_link(ti('link.delete'), icon, path,
                data: { turbo_confirm: ti(:confirm_delete),
                        method: :delete, 'turbo-method': :delete })
  end

  # Standard list action to the given path.
  # Uses the current +model_class+ if no path is given.
  def index_action_link(path = nil, url_options = { returning: true })
    path ||= path_args(model_class)
    path = polymorphic_path(path, url_options) unless path.is_a?(String)
    action_link(ti('link.list'), 'list', path)
  end

  # Standard add action to given path.
  # Uses the current +model_class+ if no path is given.
  def add_action_link(path = nil, url_options = {}, options = {})
    path ||= path_args(model_class)
    path = new_polymorphic_path(path, url_options) unless path.is_a?(String)
    action_link(ti('link.add'), 'plus', path, options)
  end

  def add_person_relation_link(path, person_relation_name, options)
    path = new_polymorphic_path(path, url_options, options) unless path.is_a?(String)
    action_link(t("people.#{person_relation_name}.link.add"), 'plus', path, options)
  end

  def add_action_link_modal(path = nil, url_options = {})
    path ||= path_args(model_class)
    path = new_polymorphic_path(path, url_options) unless path.is_a?(String)
    options = { data: { turbo_frame: 'remote_modal' } }
    action_link(ti('link.add'), 'plus', path, options)
  end

  def export_action_link(path, options = {})
    action_link(ti('link.export'), 'export', path, options)
  end

  def close_action_link(path, options = {})
    action_link('', 'close', path, options)
  end

  def cancel_action_link(path, options = {})
    action_link(ti('link.cancel'), 'cancel', path, options)
  end

  def admin_action_link(label, icon = nil, url = {}, options = {})
    add_css_class options, 'action btn btn-link d-flex align-items-center gap-2'
    add_css_class options, 'disabled' unless current_auth_user.is_admin?
    link = link_to(icon ? action_icon(icon, label) : label,
                   url, options)

    return link if current_auth_user.is_admin?

    wrap_with_tooltip(link, I18n.t('errors.messages.authorization_error'))
  end

  def admin_export_action_link(path, options = {})
    admin_action_link(ti('link.export'), 'export', path, options)
  end

  private

  def wrap_with_tooltip(link, tooltip_message)
    data = { bs_toggle: 'tooltip',
             bs_title: tooltip_message,
             controller: 'tooltip' }

    content_tag(:div, '',
                class: 'disable-btn-tooltip',
                data: data) { link }
  end

  def update_action_link(options = {})
    button_tag(
      class: add_css_class(options, 'action btn btn-link d-flex align-items-center gap-2'),
      name: 'save',
      html_options: options
    ) do
      action_icon('save', ti('link.update'))
    end
  end

  def save_action_link(options = {})
    button_tag(
      class: add_css_class(options, 'action btn btn-link d-flex align-items-center gap-2'),
      name: 'save',
      html_options: options
    ) do
      action_icon('save', ti('link.save'))
    end
  end

  def save_and_new_action_link(options = {})
    button_tag(
      class: add_css_class(options, 'action btn btn-link d-flex align-items-center gap-2'),
      name: 'render_new_after_save',
      html_options: options
    ) do
      action_icon('save-and-new', ti('link.save_new'))
    end
  end
end
