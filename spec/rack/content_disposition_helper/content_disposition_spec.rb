# frozen_string_literal: true

RSpec.describe Rack::ContentDispositionHelper::ContentDisposition, type: :lib do
  let(:filename) do
    {
      long:  {
        raw:      'なんかしらんけどContent-Dispositionの値が255Byte以上やとあかんのやて',
        raw_utf8: 'filename="なんかしらんけどContent-Dispositionの値が255Byte以上やとあかんのやて"',
        ascii:    'filename="%3F%3F%3F%3F%3F%3F%3F%3FContent-Disposition%3F%3F%3F255Byte%3F%3F' \
                  '%3F%3F%3F%3F%3F%3F%3F%3F"',
        utf8:     "filename*=UTF-8''%E3%81%AA%E3%82%93%E3%81%8B%E3%81%97%E3%82%89%E3%82%93%E3%81" \
                  '%91%E3%81%A9Content-Disposition%E3%81%AE%E5%80%A4%E3%81%8C255Byte%E4%BB%A5%E4' \
                  '%B8%8A%E3%82%84%E3%81%A8%E3%81%82%E3%81%8B%E3%82%93%E3%81%AE%E3%82%84%E3%81%A6',
      },
      short: {
        raw:      'これなら問題ないんだけどね',
        raw_utf8: 'filename="これなら問題ないんだけどね"',
        ascii:    'filename="%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F"',
        utf8:     "filename*=UTF-8''%E3%81%93%E3%82%8C%E3%81%AA%E3%82%89%E5%95%8F%E9%A1%8C%E3%81" \
                  '%AA%E3%81%84%E3%82%93%E3%81%A0%E3%81%91%E3%81%A9%E3%81%AD',
      },
    }
  end

  let(:content_disposition_value) do
    {
      long:  "attachment; #{filename[:long][:ascii]}; #{filename[:long][:utf8]}",
      short: "attachment; #{filename[:short][:ascii]}; #{filename[:short][:utf8]}",
    }
  end

  describe '#long?' do
    context 'when value is long' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new(
            content_disposition_value[:long],
          )

        expect(content_disposition).to be_long
      end
    end

    context 'when value is short' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new(
            content_disposition_value[:short],
          )

        expect(content_disposition).not_to be_long
      end
    end

    context 'when value is empty' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new('')

        expect(content_disposition).not_to be_long
      end
    end

    context 'when value is nil' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new(nil)

        expect(content_disposition).not_to be_long
      end
    end
  end

  describe '#disposition' do
    context 'when value is long' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new(
            content_disposition_value[:long],
          )

        expect(content_disposition.disposition).to eq('attachment;')
      end
    end

    context 'when value is short' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new(
            content_disposition_value[:short],
          )

        expect(content_disposition.disposition).to eq('attachment;')
      end
    end

    context 'when value is empty' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new('')

        expect(content_disposition.disposition).to be_nil
      end
    end

    context 'when value is nil' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new(nil)

        expect(content_disposition.disposition).to be_nil
      end
    end
  end

  describe '#raw_filename_value' do
    context 'when value is long' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new(
            content_disposition_value[:long],
          )

        expect(content_disposition.raw_filename_value).to eq(
          "attachment; #{filename[:long][:raw_utf8]}",
        )
      end
    end

    context 'when value is short' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new(
            content_disposition_value[:short],
          )

        expect(content_disposition.raw_filename_value).to eq(
          "attachment; #{filename[:short][:raw_utf8]}",
        )
      end
    end

    context 'when value is empty' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new('')

        expect(content_disposition.raw_filename_value).to be_nil
      end
    end

    context 'when value is nil' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new(nil)

        expect(content_disposition.raw_filename_value).to be_nil
      end
    end
  end

  describe '#raw_filename' do
    context 'when value is long' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new(
            content_disposition_value[:long],
          )

        expect(content_disposition.raw_filename).to eq(filename[:long][:raw])
      end
    end

    context 'when value is short' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new(
            content_disposition_value[:short],
          )

        expect(content_disposition.raw_filename).to eq(filename[:short][:raw])
      end
    end

    context 'when value is empty' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new('')

        expect(content_disposition.raw_filename).to be_nil
      end
    end

    context 'when value is nil' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new(nil)

        expect(content_disposition.raw_filename).to be_nil
      end
    end
  end

  describe '#filename_asterisk' do
    context 'when value is long' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new(
            content_disposition_value[:long],
          )

        expect(content_disposition.filename_asterisk).to eq(filename[:long][:utf8])
      end
    end

    context 'when value is short' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new(
            content_disposition_value[:short],
          )

        expect(content_disposition.filename_asterisk).to eq(filename[:short][:utf8])
      end
    end

    context 'when value is empty' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new('')

        expect(content_disposition.filename_asterisk).to be_nil
      end
    end

    context 'when value is nil' do
      it do
        content_disposition =
          Rack::ContentDispositionHelper::ContentDisposition.new(nil)

        expect(content_disposition.filename_asterisk).to be_nil
      end
    end
  end
end
