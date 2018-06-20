require "metanorma/processor"

module Metanorma
  module M3d
    class Processor < Metanorma::Processor

      def initialize
        @short = :m3d
        @input_format = :asciidoc
        @asciidoctor_backend = :m3d
      end

      def output_formats
        {
          html: "html",
          doc: "doc"
        }
      end

      def input_to_isodoc(file)
        Metanorma::Input::Asciidoc.new.process(file, @asciidoctor_backend)
      end

      def output(isodoc_node, outname, format, options={})
        case format
        when :html
          IsoDoc::M3d::HtmlConvert.new(options).convert(outname, isodoc_node)
        when :doc
          IsoDoc::M3d::WordConvert.new(options).convert(outname, isodoc_node)
        end
      end

    end
  end
end