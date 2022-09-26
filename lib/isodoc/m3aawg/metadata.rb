require "isodoc"

module IsoDoc
  module M3AAWG
    class Metadata < IsoDoc::Generic::Metadata
      def configuration
        Metanorma::M3AAWG.configuration
      end

      def initialize(lang, script, locale, labels)
        super
        here = File.dirname(__FILE__)
        set(:logo_html,
            File.expand_path(File.join(here, "html", "m3-logo.png")))
        set(:logo_word,
            File.expand_path(File.join(here, "html", "logo.jpg")))
      end

      def title(isoxml, _out)
        main = isoxml&.at(ns("//bibdata/title[@language='en']"))&.text
        set(:doctitle, main)
      end

      def subtitle(_isoxml, _out)
        nil
      end

      def author(isoxml, _out)
        set(:tc, nil)
        tc = isoxml.at(ns("//bibdata/ext/editorialgroup/committee"))
        set(:tc, tc.text) if tc
        super
      end

      def docid(isoxml, _out)
        docnumber = isoxml.at(ns("//bibdata/docidentifier"))
        set(:docnumber, docnumber&.text)
      end
    end
  end
end
