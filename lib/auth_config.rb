# frozen_string_literal: true

class AuthConfig

  AUTH_CONFIG_PATH = Rails.root.join('config/auth.yml')

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

    private

    def get_var_from_environment(key)
      if locale
        settings_file[key]
      else
        ENV[key.to_s] || raise("Environment variable not set: '#{key}'")
      end
    end

    def locale
      ENV.fetch('locale', true)
    end

    def settings_file
      @settings_file ||= load_file.freeze
    end

    def load_file
      if Rails.env.test? || !valid_file?
        return { provider: 'db' }
      end

      YAML.safe_load_file(AUTH_CONFIG_PATH).deep_symbolize_keys
    end

    def valid_file?
      File.exist?(AUTH_CONFIG_PATH) && !File.empty?(AUTH_CONFIG_PATH)
    end
  end
end
