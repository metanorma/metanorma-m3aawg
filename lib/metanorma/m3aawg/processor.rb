require "metanorma/processor"

module Metanorma
  module M3AAWG
    class Processor < Metanorma::Generic::Processor
      def configuration
        Metanorma::Ribose.configuration
      end

      def initialize # rubocop:disable Lint/MissingSuper
        @short = %i[m3d m3aawg]
        @input_format = :asciidoc
        @asciidoctor_backend = :m3aawg
      end

      def output_formats
        super.merge(
          html: "html",
          doc: "doc",
          pdf: "pdf",
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
          "Noto Sans" => nil,
          "Noto Sans HK" => nil,
          "Noto Sans JP" => nil,
          "Noto Sans KR" => nil,
          "Noto Sans SC" => nil,
          "Noto Sans TC" => nil,
          "Noto Sans Mono" => nil,
          "Noto Sans Mono CJK HK" => nil,
          "Noto Sans Mono CJK JP" => nil,
          "Noto Sans Mono CJK KR" => nil,
          "Noto Sans Mono CJK SC" => nil,
          "Noto Sans Mono CJK TC" => nil,
        }
      end

      def version
        "Metanorma::M3AAWG #{Metanorma::M3AAWG::VERSION}"
      end

      def output(isodoc_node, inname, outname, format, options = {})
        case format
        when :html
          IsoDoc::M3AAWG::HtmlConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        when :doc
          IsoDoc::M3AAWG::WordConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        when :pdf
          IsoDoc::M3AAWG::PdfConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        when :presentation
          IsoDoc::M3AAWG::PresentationXMLConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        else
          super
        end
      end
    end
  end
end
