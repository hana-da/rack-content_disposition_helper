# frozen_string_literal: true

require_relative 'lib/rack/content_disposition_helper/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-content_disposition_helper'
  spec.version       = Rack::ContentDispositionHelper::VERSION
  spec.authors       = ['hana-da']

  spec.summary       = 'Rack middleware that modifies Content-Disposition response header.'
  spec.description   = 'Rack::ContentDispositionHelper is Rack middleware that rewrites ' \
                       'the decoded filename* directive in the Content-Disposition response ' \
                       'header as the value of the filename directive.'
  spec.homepage      = 'https://github.com/hana-da/rack-content_disposition_helper'
  spec.license       = 'MIT'

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['bug_tracker_uri'] = "#{spec.homepage}/issues"
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.require_paths = ['lib']
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -- lib/*`.split("\n") + %w[CHANGELOG.md MIT-LICENSE README.md]
  end

  spec.required_ruby_version = Gem::Requirement.new('>= 2.7')
  spec.add_dependency 'rack', '>= 1.0', '< 4'
end
