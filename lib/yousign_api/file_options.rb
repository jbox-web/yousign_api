# frozen_string_literal: true

module YousignApi
  class FileOptions

    attr_reader :mail, :is_visible_signature, :visible_signature_page, :visible_rectangle_signature

    def initialize(opts = {})
      @mail                        = opts.fetch(:mail, '')
      @is_visible_signature        = opts.fetch(:is_visible_signature, true)
      @visible_signature_page      = opts.fetch(:visible_signature_page, 1)
      @visible_rectangle_signature = opts.fetch(:visible_rectangle_signature, '0,39,99,0')
    end

    def to_yousign
      {
        mail: mail,
        isVisibleSignature: is_visible_signature,
        visibleSignaturePage: visible_signature_page,
        visibleRectangleSignature: visible_rectangle_signature,
      }
    end

  end
end
