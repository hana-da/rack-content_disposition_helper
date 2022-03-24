# frozen_string_literal: true

module Rack
  class ContentDispositionHelper
    class UserAgent
      SAFARI_PATTERN = %r{ (:?Version|Mobile)/[0-9A-Z.]+ Safari/[0-9.]+\z}.freeze

      def initialize(env)
        @user_agent = env['HTTP_USER_AGENT']
      end

      def safari?
        @user_agent&.match?(SAFARI_PATTERN)
      end
    end
  end
end
