require_relative "base_convert"
require "isodoc"

module IsoDoc
  module M3AAWG

    # A {Converter} implementation that generates HTML output, and a document
    # schema encapsulation of the document for validation
    #
    class PdfConvert < IsoDoc::XslfoPdfConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def pdf_stylesheet(docxml)
        "m3aawg.report.xsl"
      end
    end
  end
end

