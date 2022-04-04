# Unreleased

# 0.2.0 - 2022/04/04

## Breaking Changes:

- Rename Rack::ContentDispositionHelper::ContentDisposition to Rack::ContentDispositionHelper::Converter
- Rename Rack::ContentDispositionHelper::Converter#long? to Rack::ContentDispositionHelper::Converter#length_limit_exceeded?
- Rename Rack::ContentDispositionHelper::Converter#raw_filename_value to Rack::ContentDispositionHelper::Converter#convert
- Rename Rack::ContentDispositionHelper::Converter#value to Rack::ContentDispositionHelper::Converter#original_value
- Drop support for Ruby 2.6

## Enhancement:

- Rack::ContentDispositionHelper::Converter#convert now returns the original value if the `filename*` directive does not exist

# 0.1.0 - 2022/03/24

- Initial release.
