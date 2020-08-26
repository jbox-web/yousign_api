require 'spec_helper'

describe YousignApi::Client do

  describe '.new' do
    context 'with invalid params' do
      it 'raise error when username is missing' do
        expect { described_class.new(password: 'pass', api_key: 'api_key', environment: 'demo') }.to raise_error(KeyError)
      end

      it 'raise error when password is missing' do
        expect { described_class.new(username: 'user', api_key: 'api_key', environment: 'demo') }.to raise_error(KeyError)
      end

      it 'raise error when api_key is missing' do
        expect { described_class.new(username: 'user', password: 'pass', environment: 'demo') }.to raise_error(KeyError)
      end

      it 'raise error when environment is missing' do
        expect { described_class.new(username: 'user', password: 'pass', api_key: 'api_key') }.to raise_error(KeyError)
      end

      it 'raise error when environment is not demo or prod' do
        expect { described_class.new(username: 'user', password: 'pass', api_key: 'api_key', environment: 'foo') }.to raise_error(ArgumentError)
      end
    end

    context 'with valid params' do
      it 'accepts string for environment param' do
        expect { described_class.new(username: 'user', password: 'pass', api_key: 'api_key', environment: 'demo') }.to_not raise_error
      end

      it 'accepts symbols for environment param' do
        expect { described_class.new(username: 'user', password: 'pass', api_key: 'api_key', environment: :demo) }.to_not raise_error
      end

      it 'accepts Savon options' do
        client = described_class.new(username: 'user', password: 'pass', api_key: 'api_key', environment: 'demo', soap_options: { ssl_verify_mode: :none })
        expect(client.soap_options).to eq({ ssl_verify_mode: :none })
      end

      it 'sets Soap client' do
        client = described_class.new(username: 'user', password: 'pass', api_key: 'api_key', environment: 'demo')
        expect(client.instance_variable_get('@client_auth')).to be_a(Savon::Client)
        expect(client.instance_variable_get('@client_sign')).to be_a(Savon::Client)
        expect(client.instance_variable_get('@client_arch')).to be_a(Savon::Client)
      end
    end
  end

  describe 'API urls' do
    context 'when environment is prod' do
      let(:client) { described_class.new(username: 'user', password: 'pass', api_key: 'api_key', environment: :prod) }

      describe '#env_url' do
        it 'should return YouSign API url' do
          expect(client.env_url).to eq 'api.yousign.fr:8181'
        end
      end

      describe '#url_auth' do
        it 'should return YouSign API url for authentication' do
          expect(client.url_auth).to eq 'https://api.yousign.fr:8181/AuthenticationWS/AuthenticationWS?wsdl'
        end
      end

      describe '#url_sign' do
        it 'should return YouSign API url for signing' do
          expect(client.url_sign).to eq 'https://api.yousign.fr:8181/CosignWS/CosignWS?wsdl'
        end
      end

      describe '#url_arch' do
        it 'should return YouSign API url for archives' do
          expect(client.url_arch).to eq 'https://api.yousign.fr:8181/ArchiveWS/ArchiveWS?wsdl'
        end
      end
    end

    context 'when environment is demo' do
      let(:client) { described_class.new(username: 'user', password: 'pass', api_key: 'api_key', environment: :demo) }

      describe '#env_url' do
        it 'should return YouSign API url' do
          expect(client.env_url).to eq 'apidemo.yousign.fr:8181'
        end
      end

      describe '#url_auth' do
        it 'should return YouSign API url for authentication' do
          expect(client.url_auth).to eq 'https://apidemo.yousign.fr:8181/AuthenticationWS/AuthenticationWS?wsdl'
        end
      end

      describe '#url_sign' do
        it 'should return YouSign API url for signing' do
          expect(client.url_sign).to eq 'https://apidemo.yousign.fr:8181/CosignWS/CosignWS?wsdl'
        end
      end

      describe '#url_arch' do
        it 'should return YouSign API url for archives' do
          expect(client.url_arch).to eq 'https://apidemo.yousign.fr:8181/ArchiveWS/ArchiveWS?wsdl'
        end
      end
    end
  end

  let(:client) { described_class.new(username: 'user', password: 'pass', api_key: 'api_key', environment: :demo) }
  let(:signer) { YousignApi::Signer.new('John', 'Doe', 'john@doe.com', '0123456789') }
  let(:file_option) { YousignApi::FileOptions.new(mail: 'john@doe.com') }
  let(:file) { YousignApi::File.new(fixture_path('doc.pdf'), [file_option]) }

  describe '#connect!' do
    it 'should check API connection' do
      client_auth = client.instance_variable_get('@client_auth')
      response = double('response')

      expect(client_auth).to receive(:call).and_return(response)
      expect(response).to receive(:body).and_return({ connect_response: { return: true }})

      client.connect!
    end
  end

  describe '#signature_init' do
    describe 'the first arg must be a list of YousignApi::File' do
      context 'when arg is not an array' do
        it 'should raise error' do
          expect { client.signature_init({}, [signer]) }.to raise_error(YousignApi::Error::InvalidFileList)
          expect { client.signature_init('', [signer]) }.to raise_error(YousignApi::Error::InvalidFileList)
          expect { client.signature_init(:foo, [signer]) }.to raise_error(YousignApi::Error::InvalidFileList)
          expect { client.signature_init(1, [signer]) }.to raise_error(YousignApi::Error::InvalidFileList)
        end
      end

      context 'when arg is not an array of YouSign::File' do
        it 'should raise error' do
          expect { client.signature_init([:foo, 'bar'], [signer]) }.to raise_error(YousignApi::Error::InvalidFileList)
        end
      end

      context 'when arg is empty array' do
        it 'should raise error' do
          expect { client.signature_init([], [signer]) }.to raise_error(YousignApi::Error::EmptyFileList)
        end
      end
    end

    describe 'the second arg must be a list of YousignApi::Signer' do
      context 'when arg is not an array' do
        it 'should raise error' do
          expect { client.signature_init([file], {}) }.to raise_error(YousignApi::Error::InvalidSignerList)
          expect { client.signature_init([file], '') }.to raise_error(YousignApi::Error::InvalidSignerList)
          expect { client.signature_init([file], :foo) }.to raise_error(YousignApi::Error::InvalidSignerList)
          expect { client.signature_init([file], 1) }.to raise_error(YousignApi::Error::InvalidSignerList)
        end
      end

      context 'when arg is not an array of YouSign::Signer' do
        it 'should raise error' do
          expect { client.signature_init([file], [:foo, 'bar']) }.to raise_error(YousignApi::Error::InvalidSignerList)
        end
      end

      context 'when arg is empty array' do
        it 'should raise error' do
          expect { client.signature_init([file], []) }.to raise_error(YousignApi::Error::EmptySignerList)
        end
      end
    end

    describe '#signature_init' do
      it 'should call Yousign API' do
        client_sign = client.instance_variable_get('@client_sign')
        response = double('response')

        message = {
          lstCosignedFile: [
            {
              name: 'doc.pdf',
              content: Base64.encode64(File.read(fixture_path('doc.pdf'))),
              visibleOptions: [
                {
                  mail: 'john@doe.com',
                  isVisibleSignature: true,
                  visibleSignaturePage: 1,
                  visibleRectangleSignature: '0,39,99,0'
                }
              ]
            }
          ],
          lstCosignerInfos: [
            {
              firstName: 'John',
              lastName: 'Doe',
              mail: 'john@doe.com',
              phone: '0123456789',
              authenticationMode: 'sms'
            }
          ],
          message: '',
          title: '',
          # initMailSubject: false,
          # initMail: false,
          # endMailSubject: false,
          # endMail: false,
          language: 'FR',
          mode: '',
          archive: false
        }

        expect(client_sign).to receive(:call).with(:init_cosign, message: message).and_return(response)
        expect(response).to receive(:body).and_return({ init_cosign_response: { return: true } })

        client.signature_init([file], [signer])
      end
    end
  end

  describe '#signature_list' do
    it 'should call Yousign API' do
      client_sign = client.instance_variable_get('@client_sign')
      response = double('response')

      message = {
        search: '',
        firstResult: '',
        count: 1000,
        status: '',
        dateBegin: '',
        dateEnd: ''
      }

      expect(client_sign).to receive(:call).with(:get_list_cosign, message: message).and_return(response)
      expect(response).to receive(:body).and_return({ get_list_cosign_response: { return: true } })

      client.signature_list
    end
  end

  describe '#signature_cancel' do
    it 'should call Yousign API' do
      client_sign = client.instance_variable_get('@client_sign')
      response = double('response')

      message = {
        idDemand: 1000,
      }

      expect(client_sign).to receive(:call).with(:cancel_cosignature_demand, message: message).and_return(response)
      expect(response).to receive(:body).and_return({ cancel_cosignature_demand_response: { return: true } })

      client.signature_cancel(1000)
    end
  end
end
