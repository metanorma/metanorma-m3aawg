require "metanorma-generic"

module IsoDoc
  module M3AAWG
    class Xref < IsoDoc::Xref
      def configuration
        Metanorma::M3AAWG.configuration
      end
    end
  end
end
