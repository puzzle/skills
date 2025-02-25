MiniMagick.configure do |config|
  config.graphicsmagick = Rails.env.production?
end