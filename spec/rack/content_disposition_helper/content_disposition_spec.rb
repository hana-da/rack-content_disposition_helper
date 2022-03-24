# frozen_string_literal: true

RSpec.describe Rack::ContentDispositionHelper::ContentDisposition, type: :lib do
  let(:filename) do
    {
      long:  {
        raw:      'なんかしらんけどContent-Dispositionの値が255Byte以上やとあかんのやて',
        asterisk: "filename*=UTF-8''%E3%81%AA%E3%82%93%E3%81%8B%E3%81%97%E3%82%89%E3%82%93%E3%81" \
                  '%91%E3%81%A9Content-Disposition%E3%81%AE%E5%80%A4%E3%81%8C255Byte%E4%BB%A5%E4' \
                  '%B8%8A%E3%82%84%E3%81%A8%E3%81%82%E3%81%8B%E3%82%93%E3%81%AE%E3%82%84%E3%81%A6',
      },
      short: {
        raw:      'これなら問題ないんだけどね',
        asterisk: "filename*=UTF-8''%E3%81%93%E3%82%8C%E3%81%AA%E3%82%89%E5%95%8F%E9%A1%8C%E3%81" \
                  '%AA%E3%81%84%E3%82%93%E3%81%A0%E3%81%91%E3%81%A9%E3%81%AD',
      },
    }
  end

  let(:content_disposition_value) do
    {
      long:  "attachment; filename=\"#{filename[:long][:encoded]}\"; #{filename[:long][:asterisk]}",
      short: "attachment; filename=\"#{filename[:short][:encoded]}\"; #{filename[:short][:asterisk]}",
    }
  end

  let(:content_disposition) do
    {
      long:  Rack::ContentDispositionHelper::ContentDisposition.new(content_disposition_value[:long]),
      short: Rack::ContentDispositionHelper::ContentDisposition.new(content_disposition_value[:short]),
      empty: Rack::ContentDispositionHelper::ContentDisposition.new(''),
      nil:   Rack::ContentDispositionHelper::ContentDisposition.new(nil),
    }
  end

  describe '#long?' do
    context 'when value is long' do
      it do
        expect(content_disposition[:long]).to be_long
      end
    end

    context 'when value is not long' do
      it do
        expect(content_disposition[:short]).not_to be_long
      end
    end

    context 'when value is empty' do
      it do
        expect(content_disposition[:empty]).not_to be_long
      end
    end

    context 'when value is nil' do
      it do
        expect(content_disposition[:nil]).not_to be_long
      end
    end
  end

  describe '#disposition' do
    context 'when value is long' do
      it do
        expect(content_disposition[:long].disposition).to eq('attachment;')
      end
    end

    context 'when value is not long' do
      it do
        expect(content_disposition[:short].disposition).to eq('attachment;')
      end
    end

    context 'when value is empty' do
      it do
        expect(content_disposition[:empty].disposition).to be_nil
      end
    end

    context 'when value is nil' do
      it do
        expect(content_disposition[:nil].disposition).to be_nil
      end
    end
  end

  describe '#raw_filename_value' do
    context 'when value is long' do
      it do
        expect(content_disposition[:long].raw_filename_value).to eq(
          "attachment; filename=\"#{filename[:long][:raw]}\"",
        )
      end
    end

    context 'when value is not long' do
      it do
        expect(content_disposition[:short].raw_filename_value).to eq(
          "attachment; filename=\"#{filename[:short][:raw]}\"",
        )
      end
    end

    context 'when value is empty' do
      it do
        expect(content_disposition[:empty].raw_filename_value).to be_nil
      end
    end

    context 'when value is nil' do
      it do
        expect(content_disposition[:nil].raw_filename_value).to be_nil
      end
    end
  end

  describe '#raw_filename' do
    context 'when value is long' do
      it do
        expect(content_disposition[:long].raw_filename).to eq(filename[:long][:raw])
      end
    end

    context 'when value is not long' do
      it do
        expect(content_disposition[:short].raw_filename).to eq(filename[:short][:raw])
      end
    end

    context 'when value is empty' do
      it do
        expect(content_disposition[:empty].raw_filename).to be_nil
      end
    end

    context 'when value is nil' do
      it do
        expect(content_disposition[:nil].raw_filename).to be_nil
      end
    end
  end

  describe '#filename_asterisk' do
    context 'when value is long' do
      it do
        expect(content_disposition[:long].filename_asterisk).to eq(filename[:long][:asterisk])
      end
    end

    context 'when value is not long' do
      it do
        expect(content_disposition[:short].filename_asterisk).to eq(filename[:short][:asterisk])
      end
    end

    context 'when value is empty' do
      it do
        expect(content_disposition[:empty].filename_asterisk).to be_nil
      end
    end

    context 'when value is nil' do
      it do
        expect(content_disposition[:nil].filename_asterisk).to be_nil
      end
    end
  end
end
