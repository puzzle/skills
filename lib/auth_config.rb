# frozen_string_literal: true

class AuthConfig
  AUTH_CONFIG_PATH = Rails.root.join('config/auth.yml')
  TRUTHY_VALUES = %w(t true yes y 1).freeze
  FALSEY_VALUES = %w(f false n no 0).freeze

  class << self
    def client_id
      get_var_from_environment(:client_id)
    end

    def secret
      get_var_from_environment(:secret)
    end

    def host_url
      get_var_from_environment(:host_url)
    end

    def realm
      get_var_from_environment(:realm)
    end

    def admin_role
      get_var_from_environment(:admin_role, required: false)
    end

    def keycloak?
      to_boolean(get_var_from_environment(:keycloak, required: false, default: false))
    end

    private

    def get_var_from_environment(key, required: true, default: nil)
      if local?
        settings_file[key] || default
      else
        raise("Environment variable not set: '#{key}'") if required && ENV[key.to_s.upcase].nil?

        ENV.fetch(key.to_s.upcase, default)
      end
    end

    def local?
      to_boolean(ENV.fetch('LOCAL', false))
    end

    def to_boolean(value)
      return true if TRUTHY_VALUES.include?(value.to_s)
      return false if FALSEY_VALUES.include?(value.to_s)

      raise "Invalid value '#{value}' for boolean casting"
    end

    def settings_file
      @settings_file ||= load_file.freeze
    end

    def load_file
      YAML.safe_load_file(AUTH_CONFIG_PATH).deep_symbolize_keys
    end
  end
end
