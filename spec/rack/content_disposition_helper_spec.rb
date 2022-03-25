# frozen_string_literal: true

RSpec.describe Rack::ContentDispositionHelper, type: :lib do
  subject(:middleware_response) do
    Rack::ContentDispositionHelper.new(->(_) { parent_response }).call(request_env)
  end

  let(:parent_response) { [200, parent_response_headers, 'ResponseBody'] }

  let(:user_agent) do
    {
      chrome: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ' \
              'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.74 Safari/537.36',
      safari: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ' \
              'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15',
    }
  end

  context 'when HTTP_USER_AGENT dose not exist' do
    let(:request_env) { {} }
    let(:parent_response_headers) do
      {
        'Content-Disposition' => 'attachment; ' \
                                 'filename="%3F%3F%3F%3F%3F%3F%3F%3FContent-Disposition%3F%3F%3F255Byte%3F%3F%3' \
                                 'F%3F%3F%3F%3F%3F%3F%3F"; ' \
                                 "filename*=UTF-8''%E3%81%AA%E3%82%93%E3%81%8B%E3%81%97%E3%82%89%E3%82%93%E3%81" \
                                 '%91%E3%81%A9Content-Disposition%E3%81%AE%E5%80%A4%E3%81%8C255Byte%E4%BB%A5%E4' \
                                 '%B8%8A%E3%82%84%E3%81%A8%E3%81%82%E3%81%8B%E3%82%93%E3%81%AE%E3%82%84%E3%81%A6',
      }
    end

    it do
      expect(middleware_response).to eq(parent_response)
    end
  end

  context 'when HTTP_USER_AGENT is Chrome' do
    let(:request_env) { { 'HTTP_USER_AGENT' => user_agent[:chrome] } }
    let(:parent_response_headers) do
      {
        'Content-Disposition' => 'attachment; ' \
                                 'filename="%3F%3F%3F%3F%3F%3F%3F%3FContent-Disposition%3F%3F%3F255Byte%3F%3F%3' \
                                 'F%3F%3F%3F%3F%3F%3F%3F"; ' \
                                 "filename*=UTF-8''%E3%81%AA%E3%82%93%E3%81%8B%E3%81%97%E3%82%89%E3%82%93%E3%81" \
                                 '%91%E3%81%A9Content-Disposition%E3%81%AE%E5%80%A4%E3%81%8C255Byte%E4%BB%A5%E4' \
                                 '%B8%8A%E3%82%84%E3%81%A8%E3%81%82%E3%81%8B%E3%82%93%E3%81%AE%E3%82%84%E3%81%A6',
      }
    end

    it do
      expect(middleware_response).to eq(parent_response)
    end
  end

  context 'when HTTP_USER_AGENT is Safari' do
    let(:request_env) { { 'HTTP_USER_AGENT' => user_agent[:safari] } }

    context 'when Content-Disposition dose not exist' do
      let(:parent_response_headers) { {} }

      it do
        expect(middleware_response).to eq(parent_response)
      end
    end

    context 'when Content-Disposition is empty' do
      let(:parent_response_headers) { { 'Content-Disposition'=> '' } }

      it do
        expect(middleware_response).to eq(parent_response)
      end
    end

    context 'when Content-Disposition is inline' do
      let(:parent_response_headers) { { 'Content-Disposition'=> 'inline' } }

      it do
        expect(middleware_response).to eq(parent_response)
      end
    end

    context 'when Content-Disposition is long' do
      let(:parent_response_headers) do
        {
          'Content-Disposition' => 'attachment; ' \
                                   'filename="%3F%3F%3F%3F%3F%3F%3F%3FContent-Disposition%3F%3F%3F255Byte%3F%3F%3' \
                                   'F%3F%3F%3F%3F%3F%3F%3F"; ' \
                                   "filename*=UTF-8''%E3%81%AA%E3%82%93%E3%81%8B%E3%81%97%E3%82%89%E3%82%93%E3%81" \
                                   '%91%E3%81%A9Content-Disposition%E3%81%AE%E5%80%A4%E3%81%8C255Byte%E4%BB%A5%E4' \
                                   '%B8%8A%E3%82%84%E3%81%A8%E3%81%82%E3%81%8B%E3%82%93%E3%81%AE%E3%82%84%E3%81%A6',
        }
      end

      it do
        expect(parent_response_headers['Content-Disposition'].length).to be >= 255
        expect(middleware_response).to eq [
          parent_response[0],
          { 'Content-Disposition'=>'attachment; filename="なんかしらんけどContent-Dispositionの値が255Byte以上やとあかんのやて"' },
          parent_response[2],
        ]
      end
    end

    context 'when Content-Disposition is short' do
      let(:parent_response_headers) do
        {

          'Content-Disposition' => 'attachment; ' \
                                   'filename="%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F"; ' \
                                   "filename*=UTF-8''%E3%81%93%E3%82%8C%E3%81%AA%E3%82%89%E5%95%8F%E9%A1%8C%E3%81" \
                                   '%AA%E3%81%84%E3%82%93%E3%81%A0%E3%81%91%E3%81%A9%E3%81%AD',
        }
      end

      it do
        expect(parent_response_headers['Content-Disposition'].length).to be < 255
        expect(middleware_response).to eq(parent_response)
      end
    end
  end
end
