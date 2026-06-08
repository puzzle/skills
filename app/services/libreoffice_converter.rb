# frozen_string_literal: true

require 'open3'

class LibreofficeConverter
  SCRIPT_PATH = Rails.root.join('lib/scripts/update_odt_indexes.py').to_s
  CONVERSION_TIMEOUT = 60

  def self.refresh_odt(data)
    new.refresh_odt(data)
  end

  def refresh_odt(data)
    Dir.mktmpdir do |tmpdir|
      input_path = File.join(tmpdir, 'input.odt')
      output_path = File.join(tmpdir, 'output.odt')
      File.binwrite(input_path, data)

      convert!(input_path, output_path)

      File.binread(output_path)
    end
  rescue StandardError => e
    Rails.logger.error("LibreOffice conversion failed: #{e.message}")
    data
  end

  private

  def convert!(input_path, output_path)
    stdout, stderr, status = Open3.capture3(
      'python3', SCRIPT_PATH,
      input_path, output_path
    )

    unless status.success?
      raise "LibreOffice conversion failed: #{stderr.presence || stdout}"
    end
  end
end
