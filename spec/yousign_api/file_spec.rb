require 'spec_helper'

describe YousignApi::File do

  describe '.new' do
    describe 'the second arg must be a list of YousignApi::FileOptions' do
      context 'with invalid params' do
        it 'should raise error' do
          expect { described_class.new(fixture_path('doc.pdf'), [:foo]) }.to raise_error(YousignApi::Error::InvalidFileOptionsList)
        end
      end
    end
  end

  let(:file) { described_class.new(fixture_path('doc.pdf')) }

  describe '#to_yousign' do
    it 'should return a hash' do
      expect(file.to_yousign).to eq({
        name: 'doc.pdf',
        content: Base64.encode64(File.read(fixture_path('doc.pdf'))),
        visibleOptions: []
      })
    end
  end

end
