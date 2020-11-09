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

      def colophon(body, docxml)
        section_break(body)
        body.div **{ class: "colophon" } do |div|
        end
      end

      def make_body(xml, docxml)
        body_attr = { lang: "EN-US", link: "blue", vlink: "#954F72" }
        xml.body **body_attr do |body|
          make_body2(body, docxml)
          make_body3(body, docxml)
          colophon(body, docxml)
        end
      end

      include BaseRender
      include Init
    end
  end
end
