require "metanorma/standoc/converter"
require "metanorma/generic/converter"

module Metanorma
  module M3AAWG
    class Converter < Metanorma::Generic::Converter
      XML_ROOT_TAG = "m3d-standard".freeze
      XML_NAMESPACE = "https://www.metanorma.org/ns/m3d".freeze

      register_for "m3aawg"

      def metadata_committee(node, xml)
        return unless node.attr("technical-committee")

        xml.editorialgroup do |a|
          a.committee node.attr("technical-committee"),
                      **attr_code(type: node.attr("technical-committee-type"))
          i = 2
          while node.attr("technical-committee_#{i}")
            a.committee node.attr("technical-committee_#{i}"),
                        **attr_code(type: node.attr("technical-committee-type_#{i}"))
            i += 1
          end
        end
      end

      def configuration
        Metanorma::M3AAWG.configuration
      end

      def makexml(node)
        @draft = node.attributes.has_key?("draft")
        super
      end

      def outputs(node, ret)
        File.open("#{@filename}.xml", "w:UTF-8") { |f| f.write(ret) }
        presentation_xml_converter(node).convert("#{@filename}.xml")
        html_converter(node).convert("#{@filename}.presentation.xml", nil,
                                     false, "#{@filename}.html")
        doc_converter(node).convert("#{@filename}.presentation.xml", nil,
                                    false, "#{@filename}.doc")
        pdf_converter(node)&.convert("#{@filename}.presentation.xml", nil,
                                     false, "#{@filename}.pdf")
      end

      def sections_cleanup(xml)
        super
        xml.xpath("//*[@inline-header]").each do |h|
          h.delete("inline-header")
        end
      end

      def presentation_xml_converter(node)
        IsoDoc::M3AAWG::PresentationXMLConvert.new(html_extract_attributes(node))
      end

      def html_converter(node)
        IsoDoc::M3AAWG::HtmlConvert.new(html_extract_attributes(node))
      end

      def doc_converter(node)
        IsoDoc::M3AAWG::WordConvert.new(doc_extract_attributes(node))
      end

      def pdf_converter(node)
        return nil if node.attr("no-pdf")

        IsoDoc::M3AAWG::PdfConvert.new(pdf_extract_attributes(node))
      end
    end
  end
end
