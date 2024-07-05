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
      children = Array(send_node&.children)
      children[0]
      children[1]

      # !send_node.loc.expression.to_json.start_with?('app/helpers')


      children[2]
      Array(children[2]).first


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
