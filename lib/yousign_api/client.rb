# frozen_string_literal: true

module YousignApi
  class Client

    ENVIRONMENT = {
      demo: 'apidemo.yousign.fr:8181',
      prod: 'api.yousign.fr:8181',
    }.freeze

    attr_reader :username, :password, :api_key, :environment, :soap_options
    attr_reader :env_url, :url_auth, :url_sign, :url_arch

    def initialize(opts = {})
      @username     = opts.fetch(:username)
      @password     = opts.fetch(:password)
      @api_key      = opts.fetch(:api_key)
      @environment  = opts.fetch(:environment).to_sym
      @soap_options = opts.fetch(:soap_options, {})

      raise ArgumentError unless ENVIRONMENT.key?(@environment)

      @env_url  = ENVIRONMENT[environment]
      @url_auth = "https://#{env_url}/AuthenticationWS/AuthenticationWS?wsdl"
      @url_sign = "https://#{env_url}/CosignWS/CosignWS?wsdl"
      @url_arch = "https://#{env_url}/ArchiveWS/ArchiveWS?wsdl"

      set_clients
    end

    class << self

      def hash_password(password)
        Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(password) + Digest::SHA1.hexdigest(password))
      end

    end

    def connect!
      response = @client_auth.call(:connect)
      response.body[:connect_response][:return]
    end

    # rubocop:disable Layout/LineLength, Metrics/AbcSize
    def signature_init(files_list, signers_list, opts = {})
      raise Error::InvalidFileList, "Expected a list of YousignApi::File, got #{files_list.class}" unless valid_files_list?(files_list)
      raise Error::InvalidSignerList, "Expected a list of YousignApi::Signer, got #{signers_list.class}" unless valid_signers_list?(signers_list)

      raise Error::EmptyFileList if files_list.empty?
      raise Error::EmptySignerList if signers_list.empty?

      message = {
        lstCosignedFile:  files_list.map(&:to_yousign),
        lstCosignerInfos: signers_list.map(&:to_yousign),
        message:          opts.fetch(:message, ''),
        title:            opts.fetch(:title, ''),
        # initMailSubject:  opts.fetch(:init_mail_subject, false),
        # initMail:         opts.fetch(:init_mail, false),
        # endMailSubject:   opts.fetch(:end_mail_subject, false),
        # endMail:          opts.fetch(:end_mail, false),
        language:         opts.fetch(:language, 'FR'),
        mode:             opts.fetch(:mode, ''),
        archive:          opts.fetch(:archive, false),
      }

      response = @client_sign.call(:init_cosign, message: message)
      response.body[:init_cosign_response][:return]
    end
    # rubocop:enable Layout/LineLength, Metrics/AbcSize

    def signature_list(opts = {})
      message = {
        search:      opts.fetch(:search, ''),
        firstResult: opts.fetch(:firstResult, ''),
        count:       opts.fetch(:count, 1000),
        status:      opts.fetch(:status, ''),
        dateBegin:   opts.fetch(:dateBegin, ''),
        dateEnd:     opts.fetch(:dateEnd, ''),
      }

      response = @client_sign.call(:get_list_cosign, message: message)
      response.body[:get_list_cosign_response][:return]
    end

    def signature_details(id_demand, token = '')
      message = {
        idDemand: id_demand,
        token: token,
      }

      response = @client_sign.call(:get_infos_from_cosignature_demand, message: message)
      response.body[:get_infos_from_cosignature_demand_response][:return]
    end

    def get_signed_files(id_demand, token = '', id_file = '')
      message = {
        idDemand: id_demand,
        token:    token,
        idFile:   id_file,
      }

      response = @client_sign.call(:get_cosigned_files_from_demand, message: message)
      response.body[:get_cosigned_files_from_demand_response][:return]
    end

    def signature_cancel(id_demand)
      message = {
        idDemand: id_demand,
      }

      response = @client_sign.call(:cancel_cosignature_demand, message: message)
      response.body[:cancel_cosignature_demand_response][:return]
    end

    def alert_cosigners(id_demand, opts = {})
      message = {
        idDemand:    id_demand,
        mailSubject: opts.fetch(:mailSubject, ''),
        mail:        opts.fetch(:mail, ''),
        language:    opts.fetch(:language, 'FR'),
      }

      response = @client_sign.call(:alert_cosigners, message: message)
      response.body[:alert_cosigners_response][:return]
    end

    private

    def set_clients
      @client_auth = new_soap_client(url_auth)
      @client_sign = new_soap_client(url_sign)
      @client_arch = new_soap_client(url_arch)
    end

    def new_soap_client(url)
      options = soap_options.merge(wsdl: url, soap_header: soap_headers)
      Savon.client(options)
    end

    def soap_headers
      { username: username, password: password_hashed, apikey: api_key }
    end

    def password_hashed
      @password_hashed ||= self.class.hash_password(password)
    end

    def valid_files_list?(list)
      list.is_a?(Array) && list.reject { |o| o.is_a?(YousignApi::File) }.empty?
    end

    def valid_signers_list?(list)
      list.is_a?(Array) && list.reject { |o| o.is_a?(YousignApi::Signer) }.empty?
    end

  end
end
