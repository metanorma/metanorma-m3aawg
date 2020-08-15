require "asciidoctor"
require "metanorma/m3aawg/version"
require "isodoc/m3aawg/html_convert"
require "isodoc/m3aawg/word_convert"
require "isodoc/m3aawg/pdf_convert"
require "asciidoctor/standoc/converter"
require "fileutils"
require_relative "./validate.rb"

module Asciidoctor
  module M3AAWG

    # A {Converter} implementation that generates M3D output, and a document
    # schema encapsulation of the document for validation
    class Converter < Standoc::Converter
      XML_ROOT_TAG = "m3d-standard".freeze
      XML_NAMESPACE = "https://www.metanorma.org/ns/m3d".freeze

      register_for "m3aawg"

      def default_publisher
        "Messaging Malware and Mobile Anti-Abuse Working Group"
      end

      def metadata_committee(node, xml)
        return unless node.attr("technical-committee")
        xml.editorialgroup do |a|
          a.committee node.attr("technical-committee"),
            **attr_code(type: node.attr("technical-committee-type"))
          i = 2
          while node.attr("technical-committee_#{i}") do
            a.committee node.attr("technical-committee_#{i}"),
              **attr_code(type: node.attr("technical-committee-type_#{i}"))
            i += 1
          end
        end
      end

      def metadata_id(node, xml)
        docstatus = node.attr("status")
        dn = node.attr("docnumber")
        if docstatus
          abbr = IsoDoc::M3AAWG::Metadata.new("en", "Latn", @i18n).
            stage_abbr(docstatus)
          dn = "#{dn}(#{abbr})" unless abbr.empty?
        end
        node.attr("copyright-year") and dn += ":#{node.attr("copyright-year")}"
        xml.docidentifier dn, **{type: "M3AAWG"}
        xml.docnumber { |i| i << node.attr("docnumber") }
      end

      def title_validate(root)
        nil
      end

      def makexml(node)
        @draft = node.attributes.has_key?("draft")
        super
      end

      def doctype(node)
        d = super
        unless %w{policy best-practices supporting-document report}.include? d
          @log.add("Document Attributes", nil, "#{d} is not a legal document type: reverting to 'report'")
          d = "report"
        end
        d
      end

      def outputs(node, ret)
        File.open(@filename + ".xml", "w:UTF-8") { |f| f.write(ret) }
        presentation_xml_converter(node).convert(@filename + ".xml")
        html_converter(node).convert(@filename + ".presentation.xml", nil, false, "#{@filename}.html")
        doc_converter(node).convert(@filename + ".presentation.xml", nil, false, "#{@filename}.doc")
        pdf_converter(node)&.convert(@filename + ".presentation.xml", nil, false, "#{@filename}.pdf")
      end

      def validate(doc)
        content_validate(doc)
        schema_validate(formattedstr_strip(doc.dup),
                        File.join(File.dirname(__FILE__), "m3d.rng"))
      end

      def sections_cleanup(x)
        super
        x.xpath("//*[@inline-header]").each do |h|
          h.delete("inline-header")
        end
      end

      def style(n, t)
        return
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
        IsoDoc::M3AAWG::PdfConvert.new(doc_extract_attributes(node))
      end
    end
  end
end
