# frozen_string_literal: true

RSpec.describe Rack::ContentDispositionHelper, type: :lib do
  subject(:middleware_response) do
    Rack::ContentDispositionHelper.new(
      ->(_) { [200, original_response_headers, 'Body'] },
    ).call(request_env)
  end

  let(:user_agent) do
    {
      chrome: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ' \
              'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.74 Safari/537.36',
      safari: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ' \
              'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15',
    }
  end

  let(:filename) do
    {
      long:  {
        raw:      'なんかしらんけどContent-Dispositionの値が255Byte以上やとあかんのやて',
        encoded:  '%3F%3F%3F%3F%3F%3F%3F%3FContent-Disposition%3F%3F%3F255Byte%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F',
        asterisk: '%E3%81%AA%E3%82%93%E3%81%8B%E3%81%97%E3%82%89%E3%82%93%E3%81' \
                  '%91%E3%81%A9Content-Disposition%E3%81%AE%E5%80%A4%E3%81%8C' \
                  '255Byte%E4%BB%A5%E4%B8%8A%E3%82%84%E3%81%A8%E3%81%82%E3%81' \
                  '%8B%E3%82%93%E3%81%AE%E3%82%84%E3%81%A6',

      },
      short: {
        raw:      'これなら問題ないんだけどね',
        encoded:  '%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F',
        asterisk: '%E3%81%93%E3%82%8C%E3%81%AA%E3%82%89%E5%95%8F%E9%A1%8C%E3%81' \
                  '%AA%E3%81%84%E3%82%93%E3%81%A0%E3%81%91%E3%81%A9%E3%81%AD',
      },
    }
  end

  let(:content_disposition) do
    {
      long:  "attachment; filename=\"#{filename[:long][:encoded]}\"; filename*=UTF-8''#{filename[:long][:asterisk]}",
      short: "attachment; filename=\"#{filename[:short][:encoded]}\"; filename*=UTF-8''#{filename[:short][:asterisk]}",
    }
  end

  context 'when HTTP_USER_AGENT dose not exist' do
    let(:request_env) { {} }
    let(:original_response_headers) { { 'Content-Disposition'=> content_disposition[:long] } }

    it do
      expect(middleware_response).to eq [
        200,
        original_response_headers,
        'Body',
      ]
    end
  end

  context 'when HTTP_USER_AGENT is Chrome' do
    let(:request_env) { { 'HTTP_USER_AGENT' => user_agent[:chrome] } }
    let(:original_response_headers) { { 'Content-Disposition'=> content_disposition[:long] } }

    it do
      expect(middleware_response).to eq [
        200,
        original_response_headers,
        'Body',
      ]
    end
  end

  context 'when HTTP_USER_AGENT is Safari' do
    let(:request_env) { { 'HTTP_USER_AGENT' => user_agent[:safari] } }

    context 'when Content-Disposition dose not exist' do
      let(:original_response_headers) { {} }

      it do
        expect(middleware_response).to eq [
          200,
          original_response_headers,
          'Body',
        ]
      end
    end

    context 'when Content-Disposition is empty' do
      let(:original_response_headers) { { 'Content-Disposition'=> '' } }

      it do
        expect(middleware_response).to eq [
          200,
          original_response_headers,
          'Body',
        ]
      end
    end

    context 'when Content-Disposition is inline' do
      let(:original_response_headers) { { 'Content-Disposition'=> 'inline' } }

      it do
        expect(middleware_response).to eq [
          200,
          original_response_headers,
          'Body',
        ]
      end
    end

    context 'when Content-Disposition is long' do
      let(:original_response_headers) { { 'Content-Disposition'=> content_disposition[:long] } }

      it do
        expect(original_response_headers['Content-Disposition'].length).to be >= 255
        expect(middleware_response).to eq [
          200,
          { 'Content-Disposition'=>'attachment; filename="なんかしらんけどContent-Dispositionの値が255Byte以上やとあかんのやて"' },
          'Body',
        ]
      end
    end

    context 'when Content-Disposition is short' do
      let(:original_response_headers) { { 'Content-Disposition'=> content_disposition[:short] } }

      it do
        expect(original_response_headers['Content-Disposition'].length).to be < 255
        expect(middleware_response).to eq [
          200,
          original_response_headers,
          'Body',
        ]
      end
    end
  end
end
