# frozen_string_literal: true

require 'rack/content_disposition_helper/version'

require 'rack/content_disposition_helper/user_agent'
require 'rack/content_disposition_helper/converter'

require 'rack/content_disposition_helper/railtie' if defined?(::Rails::Railtie)

module Rack
  class ContentDispositionHelper
    def initialize(app)
      @app = app
    end

    def call(env)
      status_code, headers, body = @app.call(env)

      user_agent = UserAgent.new(env)
      converter = Converter.new(headers['Content-Disposition'])

      if converter.length_limit_exceeded? && user_agent.safari?
        headers = headers.merge('Content-Disposition' => converter.convert)
      end

      [status_code, headers, body]
    end
  end
end
