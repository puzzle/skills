# frozen_string_literal: true

class SilentLogger
  def initialize(app, silent_paths: [])
    @app = app
    @silent_paths = silent_paths
  end

  def call(env)
    if @silent_paths.include?(env['PATH_INFO'])
      Rails.logger.silence { @app.call(env) }
    else
      @app.call(env)
    end
  end
end
