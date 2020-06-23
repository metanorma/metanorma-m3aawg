require "metanorma/processor"

module Metanorma
  module M3d
    def self.fonts_used
      {
        html: ["Overpass", "Space Mono"],
        doc: ["Garamond", "Courier New"],
        pdf: ["Garamond", "Courier New"]
      }
    end

    class Processor < Metanorma::Processor

      def initialize
        @short = :m3d
        @input_format = :asciidoc
        @asciidoctor_backend = :m3d
      end

      def output_formats
        super.merge(
          html: "html",
          doc: "doc",
          pdf: "pdf"
        )
      end

      def version
        "Metanorma::M3d #{Metanorma::M3d::VERSION}"
      end

      def input_to_isodoc(file, filename)
        Metanorma::Input::Asciidoc.new.process(file, filename, @asciidoctor_backend)
      end

      def output(isodoc_node, inname, outname, format, options={})
        case format
        when :html
          IsoDoc::M3d::HtmlConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :doc
          IsoDoc::M3d::WordConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :pdf
          IsoDoc::M3d::WordConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :presentation
          IsoDoc::M3d::PresentationXMLConvert.new(options).convert(inname, isodoc_node, nil, outname)
        else
          super
        end
      end

    end
  end
end
