# frozen_string_literal: true

RSpec.describe Rack::ContentDispositionHelper::UserAgent, type: :lib do
  describe '#safari?' do
    context 'when HTTP_USER_AGENT is macOS Chrome' do
      it do
        env = {
          'HTTP_USER_AGENT' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ' \
                               'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.74 Safari/537.36',
        }
        expect(Rack::ContentDispositionHelper::UserAgent.new(env)).not_to be_safari
      end
    end

    context 'when HTTP_USER_AGENT is iOS Chrome' do
      it do
        env = {
          'HTTP_USER_AGENT' => 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_4 like Mac OS X) ' \
                               'AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.59 Mobile/15E148 Safari/604.1',
        }
        expect(Rack::ContentDispositionHelper::UserAgent.new(env)).to be_safari
      end
    end

    context 'when HTTP_USER_AGENT is Android Chrome' do
      it do
        env = {
          'HTTP_USER_AGENT' => 'Mozilla/5.0 (Linux; Android 11; Pixel 4) ' \
                               'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.210 Mobile Safari/537.36',
        }
        expect(Rack::ContentDispositionHelper::UserAgent.new(env)).not_to be_safari
      end
    end

    context 'when HTTP_USER_AGENT is macOS Safari' do
      it do
        env = {
          'HTTP_USER_AGENT' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ' \
                               'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15',
        }
        expect(Rack::ContentDispositionHelper::UserAgent.new(env)).to be_safari
      end
    end

    context 'when HTTP_USER_AGENT is iOS Safari' do
      it do
        env = {
          'HTTP_USER_AGENT' => 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_4 like Mac OS X) ' \
                               'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1',
        }
        expect(Rack::ContentDispositionHelper::UserAgent.new(env)).to be_safari
      end
    end

    context 'when HTTP_USER_AGENT is nil' do
      it do
        env = {
          'HTTP_USER_AGENT' => nil,
        }
        expect(Rack::ContentDispositionHelper::UserAgent.new(env)).not_to be_safari
      end
    end

    context 'when HTTP_USER_AGENT dose not exist' do
      it do
        env = {}
        expect(Rack::ContentDispositionHelper::UserAgent.new(env)).not_to be_safari
      end
    end

    context 'when HTTP_USER_AGENT is empty' do
      it do
        env = {
          'HTTP_USER_AGENT' => '',
        }
        expect(Rack::ContentDispositionHelper::UserAgent.new(env)).not_to be_safari
      end
    end
  end
end
