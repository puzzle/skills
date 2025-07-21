# frozen_string_literal: true

class PictureUploader < CarrierWave::Uploader::Base

  EXTENSION_WHITE_LIST = %w[jpg jpeg gif png svg bmp].freeze

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Process files as they are uploaded:
  process resize_to_fill: [200, 200]

  class << self
    def accept_extensions
      EXTENSION_WHITE_LIST.collect { |e| ".#{e}" }.join(',')
    end
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    Rails.root.join("public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}").to_s
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    ActionController::Base.helpers.asset_path(png_name)
  end

  def png_name
    "#{['profil', version_name].compact.join('_')}.png"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    EXTENSION_WHITE_LIST
  end

  def size_range
    (1.byte)..(10.megabytes)
  end
end
