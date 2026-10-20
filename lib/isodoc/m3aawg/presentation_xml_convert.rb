require_relative "init"
require "metanorma-generic"
require "isodoc"

module IsoDoc
  module M3AAWG
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def configuration
        Metanorma::M3AAWG.configuration
      end

      include Init
    end
  end
end
