require 'spec_helper'

describe YousignApi::FileOptions do

  let(:file_options) { described_class.new }

  describe '#to_yousign' do
    it 'should return a hash' do
      expect(file_options.to_yousign).to eq({
        mail: '',
        isVisibleSignature: true,
        visibleSignaturePage: 1,
        visibleRectangleSignature: '0,39,99,0',
      })
    end
  end

end
