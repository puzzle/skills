# frozen_string_literal: true

# Rubyzip 3.x uses ZIP64 format by default, which is not supported by
# LibreOffice's ODF parser. Disable it to ensure ODT exports work correctly.
Zip.write_zip64_support = false

