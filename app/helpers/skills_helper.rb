# frozen_string_literal: true

module SkillsHelper

  def default_set_button(value, label)
    active = params[:defaultSet] == value

    button_tag(
      label,
      id: "default_set_#{value}",
      type: 'button',
      class: "btn btn-outline-primary filter-button-highlight #{'active-filter-button' if active}",
      data: { action: 'click->skillset-selected#setDefaultSet',
              skillset_selected_target: 'button', value: value }
    )
  end
end
