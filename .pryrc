# 1. ALLGEMEINE EINSTELLUNGEN
Pry.config.editor = 'nvim'
Pry.config.pager = false

# 2. PROMPT PERSONALISIERUNG
Pry.config.prompt_name = "skills"

Pry.config.prompt = Pry::Prompt.new(
  "Custom",
  "Mein benutzerdefinierter Prompt",
  [
    proc { |target_self, nest_level, pry|
      "[#{RUBY_VERSION}] #{pry.config.prompt_name}(#{Pry.view_clip(target_self)})> "
    },
    proc { |target_self, nest_level, pry|
      "[#{RUBY_VERSION}] #{pry.config.prompt_name}(#{Pry.view_clip(target_self)})* "
    }
  ]
)

# 3. ALIASE
Pry.commands.alias_command 'c', 'continue'
Pry.commands.alias_command 'u', 'up'
Pry.commands.alias_command 'd', 'down'
Pry.commands.alias_command 's', 'step'
Pry.commands.alias_command 'n', 'next'
Pry.commands.alias_command 'q', 'exit'

# 4. FORMATIERUNG (AMAZING PRINT)
begin
  require 'amazing_print'
  Pry.config.print = proc { |output, value| output.puts value.ai }

  AmazingPrint.defaults = {
    indent:    2,
    sort_keys: true,
    color: {
      hash:   :yellow,
      class:  :white,
      array:  :cyan,
      string: :green,
      fixnum: :red,
      symbol: :blue
    }
  }
rescue LoadError

end

def clear
  system('clear')
end
