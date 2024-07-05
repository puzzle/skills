# frozen_string_literal: true

require_relative '../../app/helpers/i18n_helper'
require_relative '../../app/helpers/actions_helper'

module CustomTranslationMatchers
  class DryCrudTiScanner < I18n::Tasks::Scanners::AstMatchers::BaseMatcher
    include I18nHelper



    def convert_to_key_occurrences(send_node, _method_name, location: send_node.loc)
      human_attribute_name_to_key_occurences(send_node: send_node, location: location)
    end

    private

    def human_attribute_name_to_key_occurences(send_node:, location:) # rubocop:disable Metrics/MethodLength
      methods_check = %i[action_link
                         action_icon
                         show_action_link
                         edit_action_link
                         destroy_action_link
                         index_action_link
                         add_action_link
                         add_action_link_modal
                         export_action_link
                         close_action_link
                         cancel_action_link]
      children = Array(send_node&.children)
      receiver = children[0]
      method_name = children[1]

      # !send_node.loc.expression.to_json.start_with?('app/helpers')


      value = children[2]
      string = Array(children[2]).first


      key = 'activerecord.attributes.tet'
      [
        key,
        I18n::Tasks::Scanners::Results::Occurrence.from_range(
          raw_key: key,
          range: location.expression
        )
      ]
    end

    def underscore(value)
      value = value.dup.to_s
      value.gsub!(/(.)([A-Z])/, '\1_\2')
      value.downcase!
    end
  end
end
