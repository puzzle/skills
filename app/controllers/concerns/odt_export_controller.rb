module OdtExportController
  extend ActiveSupport::Concern

  private

  def filename(name, type = nil)
    return "#{name.downcase.tr(' ', '_')}_#{type}.odt" if type
    "#{name.downcase.tr(' ', '_')}.odt"
  end

  def format_odt?
    response.request.filtered_parameters['format'] == 'odt'
  end

  # UTF-8 Content-Disposition https://tools.ietf.org/html/rfc6266
  def content_disposition(disposition, filename)
    "#{disposition}; " \
      "#{content_disposition_filename_ascii(filename)}; " \
      "#{content_disposition_filename_utf8(filename)}"
  end

  def content_disposition_filename_ascii(filename)
    'filename="' +
      percent_escape(
        I18n.transliterate(filename),
        /[^ A-Za-z0-9!#{$+}.^_`|~-]/
      ) + '"'
  end

  def content_disposition_filename_utf8(filename)
    "filename*=UTF-8''" +
      percent_escape(
        filename,
        /[^A-Za-z0-9!#{$&}+.^_`|~-]/
      )
  end

  def percent_escape(string, pattern)
    string.gsub(pattern) do |char|
      char.bytes.map { |byte| format('%%%02X', byte) }.join
    end
  end

end
