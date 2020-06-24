# frozen_string_literal: true

module YousignApi
  class File

    attr_reader :file, :name, :options

    # rubocop:disable Layout/LineLength
    def initialize(file, options = [])
      @file    = file
      @name    = ::File.basename(file)
      @options = options

      raise Error::InvalidFileOptionsList, "Expected a list of YousignApi::FileOptions, got #{options.class}" unless valid_file_options?(options)
    end
    # rubocop:enable Layout/LineLength

    def to_yousign
      {
        name: name,
        content: encoded_content,
        visibleOptions: options.map(&:to_yousign),
      }
    end

    private

    def valid_file_options?(list)
      list.is_a?(Array) && list.reject { |o| o.is_a?(YousignApi::FileOptions) }.empty?
    end

    def encoded_content
      @encoded_content ||= Base64.encode64(content)
    end

    def content
      @content ||= ::File.read(file)
    end

  end
end
