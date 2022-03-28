# Unreleased

## Breaking Changes:

- Rename Rack::ContentDispositionHelper::ContentDisposition to Rack::ContentDispositionHelper::Converter
- Rename Rack::ContentDispositionHelper::Converter#long? to Rack::ContentDispositionHelper::Converter#length_limit_exceeded?
- Rename Rack::ContentDispositionHelper::Converter#raw_filename_value to Rack::ContentDispositionHelper::Converter#convert

# 0.1.0 - 2022/03/24

- Initial release.
