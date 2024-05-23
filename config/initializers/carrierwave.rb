CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  end

  config.root = Rails.root unless Rails.env.test?
end
