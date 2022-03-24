# frozen_string_literal: true

module Rack
  class ContentDispositionHelper
    class Railtie < ::Rails::Railtie
      initializer 'rack-content_disposition_helper.middleware_use' do |app|
        app.middleware.use Rack::ContentDispositionHelper
      end
    end
  end
end
