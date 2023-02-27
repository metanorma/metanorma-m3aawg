require "isodoc"
require_relative "base_convert"
require "isodoc/generic/word_convert"
require_relative "init"

module IsoDoc
  module M3AAWG
    class WordConvert < IsoDoc::Generic::WordConvert
      def configuration
        Metanorma::M3AAWG.configuration
      end

      def colophon(_docxml, body)
        section_break(body)
        body.div class: "colophon" do |div|
        end
      end

      include BaseRender
      include Init
    end
  end
end
