# frozen_string_literal: true

# Fix for odf-report gem with rubyzip 3.x
# The ODF specification requires the 'mimetype' file to be:
# 1. First in the archive
# 2. Stored uncompressed (STORED method, not DEFLATE)
#
# Rubyzip 3.x changed default compression behavior, causing odf-report
# to generate invalid ODT files that LibreOffice reports as "corrupt".
#
# Additionally, rubyzip 3.x uses ZIP64 format by default, which is not
# supported by LibreOffice's ODF parser.
#
# This patch:
# 1. Disables ZIP64 globally
# 2. Ensures mimetype is written with compression_method = STORED

Zip.write_zip64_support = false

module ODFReport
  class Template
    alias_method :original_update_file, :update_file

    def update_file(name, data)
      if name == 'mimetype'
        # ODF spec requires mimetype to be stored uncompressed
        entry = Zip::Entry.new(nil, name)
        entry.compression_method = Zip::Entry::STORED
        @output_stream.put_next_entry(entry)
        @output_stream.write(data)
      else
        original_update_file(name, data)
      end
    end
  end
end
