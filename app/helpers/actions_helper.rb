# Helpers to create action links. This default implementation supports
# regular links with an icon and a label. To change the general style
# of action links, change the method #action_link, e.g. to generate a button.
# The common crud actions show, edit, destroy, index and add are provided here.
module ActionsHelper

  # A generic helper method to create action links.
  # These link could be styled to look like buttons, for example.
  def action_link(label, icon = nil, url = {}, html_options = {})
    add_css_class html_options, 'action btn btn-link d-flex align-items-center gap-2'
    link_to(icon ? action_icon(icon, label) : label,
            url, html_options)
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
  def edit_action_link(path = nil)
    path ||= path_args(entry)
    path = edit_polymorphic_path(path) unless path.is_a?(String)
    action_link(ti('link.edit'), 'pencil', path)
  end

  # Standard destroy action to the given path.
  # Uses the current +entry+ if no path is given.
  def destroy_action_link(path = nil)
    path ||= path_args(entry)
    action_link(ti('link.delete'), 'remove', path,
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
  def add_action_link(path = nil, url_options = {}, html_options = {})
    path ||= path_args(model_class)
    path = new_polymorphic_path(path, url_options) unless path.is_a?(String)
    action_link(ti('link.add'), 'plus', path, html_options)
  end

  def add_person_relation_link(path, person_relation_name, html_options)
    path = new_polymorphic_path(path, url_options, html_options) unless path.is_a?(String)
    action_link(t("people.#{person_relation_name}.link.add"), 'plus', path, html_options)
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
    action_link(ti('link.cancel'), '', path, options)
  end

  def admin_action_link(label, icon = nil, url = {}, html_options = {})
    add_css_class html_options, 'action btn btn-link d-flex align-items-center gap-2'
    add_css_class html_options, 'disabled' unless current_auth_user.is_admin?
    link = link_to(icon ? action_icon(icon, label) : label,
                   url, html_options)

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
end
