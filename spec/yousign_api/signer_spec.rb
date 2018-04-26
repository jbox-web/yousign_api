require 'spec_helper'

describe YousignApi::Signer do

  let(:signer) { described_class.new('John', 'Doe', 'john@doe.com', '0123456789') }

  describe '#to_yousign' do
    it 'should return a hash' do
      expect(signer.to_yousign).to eq({
        firstName: 'John',
        lastName: 'Doe',
        mail: 'john@doe.com',
        phone: '0123456789',
        authenticationMode: 'sms',
      })
    end
  end

end
