# frozen_string_literal: true

require 'cgi'

module Rack
  class ContentDispositionHelper
    class Converter
      LIMIT = 254
      FILENAME_ASTERISK_PREFIX = "filename*=UTF-8''"

      attr_reader :original_value, :parts

      def initialize(original_value)
        @original_value = original_value
        @parts = original_value&.split
      end

      def length_limit_exceeded?
        return nil unless original_value

        original_value.length > LIMIT
      end

      def disposition
        parts&.first
      end

      def convert
        return original_value if !disposition || !raw_filename

        "#{disposition} filename=\"#{raw_filename}\""
      end

      def raw_filename
        @raw_filename ||= filename_asterisk&.then { |v| CGI.unescape(v).delete_prefix!(FILENAME_ASTERISK_PREFIX) }
      end

      def filename_asterisk
        parts&.find { |d| d.start_with?(FILENAME_ASTERISK_PREFIX) }
      end
    end
  end
end
