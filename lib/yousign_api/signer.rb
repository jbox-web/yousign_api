# frozen_string_literal: true

module YousignApi
  class Signer

    attr_reader :first_name, :last_name, :mail, :phone, :authentication_mode

    def initialize(first_name, last_name, mail, phone, authentication_mode = 'sms')
      @first_name = first_name
      @last_name  = last_name
      @mail       = mail
      @phone      = phone
      @authentication_mode = authentication_mode
    end

    def to_yousign
      {
        firstName:          first_name,
        lastName:           last_name,
        mail:               mail,
        phone:              phone,
        authenticationMode: authentication_mode
      }
    end

  end
end
