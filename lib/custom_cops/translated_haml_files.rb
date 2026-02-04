require 'rubocop'

module CustomCops
  class TranslatedHamlFiles < RuboCop::Cop::Base
    MSG = 'Each line in a HAML file must start with `=`, `-`, or `%`.'.freeze


    def on_new_investigation
      return unless haml_file?

      processed_source.lines.each_with_index do |line, index|
        next if line.strip.empty? || line.strip.start_with?('=', '-', '%')

        add_offense(processed_source.buffer,
                    location: source_range(processed_source.buffer, index + 1, 0, line.length))
      end
    end

    private

    def haml_file?
      processed_source.buffer.name.end_with?('.haml')
    end
  end
end
