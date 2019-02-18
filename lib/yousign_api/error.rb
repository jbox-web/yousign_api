# frozen_string_literal: true

module YousignApi
  module Error
    class YousignApiError   < StandardError;   end
    class InvalidFileList   < YousignApiError; end
    class EmptyFileList     < YousignApiError; end
    class InvalidSignerList < YousignApiError; end
    class EmptySignerList   < YousignApiError; end
    class InvalidFileOptionsList < YousignApiError; end
  end
end
