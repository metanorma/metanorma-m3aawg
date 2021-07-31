require "metanorma/processor"

module Metanorma
  module M3AAWG
    class Processor < Metanorma::Generic::Processor
       def configuration
        Metanorma::Ribose.configuration
      end

      def initialize
        @short = [:m3d, :m3aawg]
        @input_format = :asciidoc
        @asciidoctor_backend = :m3aawg
      end

      def output_formats
        super.merge(
          html: "html",
          doc: "doc",
          pdf: "pdf"
        )
      end

      def fonts_manifest
        {
          "Arial" => nil,
          "Cambria Math" => nil,
          "Courier New" => nil,
          "EB Garamond 12" => nil,
          "Overpass" => nil,
          "Space Mono" => nil,
        }
      end

      def version
        "Metanorma::M3AAWG #{Metanorma::M3AAWG::VERSION}"
      end

      def output(isodoc_node, inname, outname, format, options={})
        case format
        when :html
          IsoDoc::M3AAWG::HtmlConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :doc
          IsoDoc::M3AAWG::WordConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :pdf
          IsoDoc::M3AAWG::PdfConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :presentation
          IsoDoc::M3AAWG::PresentationXMLConvert.new(options).convert(inname, isodoc_node, nil, outname)
        else
          super
        end
      end

    end
  end
end
