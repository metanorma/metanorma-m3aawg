module IsoDoc
  module M3AAWG
    class I18n < IsoDoc::Generic::I18n
      def configuration
        Metanorma::M3AAWG.configuration
      end
    end
  end
end
