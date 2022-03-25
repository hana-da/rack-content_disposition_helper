# frozen_string_literal: true

RSpec.describe Rack::ContentDispositionHelper, type: :lib do
  subject(:middleware_response) do
    Rack::ContentDispositionHelper.new(->(_) { parent_response }).call(request_env)
  end

  let(:parent_response) { [200, parent_response_headers, 'ResponseBody'] }

  let(:user_agent) do
    {
      android_chrome: 'Mozilla/5.0 (Linux; Android 12; Pixel 5) ' \
                      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.73 Mobile Safari/537.36',
      macos_chrome:   'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ' \
                      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.83 Safari/537.36',
      macos_firefox:  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:98.0) Gecko/20100101 Firefox/98.0',
      windows_chrome: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) ' \
                      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.83 Safari/537.36',
      # ----------------------------------------------------------------------------------------------------
      ios_chrome:     'Mozilla/5.0 (iPhone; CPU iPhone OS 15_4 like Mac OS X) ' \
                      'AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/99.0.4844.59 Mobile/15E148 Safari/604.1',
      ios_safari:     'Mozilla/5.0 (iPhone; CPU iPhone OS 15_4 like Mac OS X) ' \
                      'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1',
      macos_safari:   'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ' \
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

  where(:case_name, :key) do
    [
      ['when HTTP_USER_AGENT is Android Chrome', :android_chrome],
      ['when HTTP_USER_AGENT is macOS Chrome',   :macos_chrome],
      ['when HTTP_USER_AGENT is macOS Firefox',  :macos_firefox],
      ['when HTTP_USER_AGENT is Windows Chrome', :windows_chrome],
    ]
  end

  with_them do
    context 'when HTTP_USER_AGENT is Chrome' do
      let(:request_env) { { 'HTTP_USER_AGENT' => user_agent[key] } }
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
  end

  where(:case_name, :key) do
    [
      ['when HTTP_USER_AGENT is iOS Safari',   :ios_safari],
      ['when HTTP_USER_AGENT is macOS Safari', :macos_safari],
    ]
  end

  with_them do
    let(:request_env) { { 'HTTP_USER_AGENT' => user_agent[key] } }

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
