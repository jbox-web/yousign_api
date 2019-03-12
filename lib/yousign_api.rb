# frozen_string_literal: true

require 'digest/sha1'
require 'savon'

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.setup

module YousignApi
end
