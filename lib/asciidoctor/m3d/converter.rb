require "asciidoctor"
require "metanorma/m3d/version"
require "isodoc/m3d/html_convert"
require "isodoc/m3d/word_convert"
require "isodoc/m3d/pdf_convert"
require "asciidoctor/standoc/converter"
require "fileutils"
require_relative "./validate.rb"

module Asciidoctor
  module M3d

    # A {Converter} implementation that generates M3D output, and a document
    # schema encapsulation of the document for validation
    class Converter < Standoc::Converter
      XML_ROOT_TAG = "m3d-standard".freeze
      XML_NAMESPACE = "https://www.metanorma.org/ns/m3d".freeze

      register_for "m3d"

      def metadata_author(node, xml)
        xml.contributor do |c|
          c.role **{ type: "author" }
          c.organization do |a|
            a.name "Messaging Malware and Mobile Anti-Abuse Working Group"
            a.abbreviation "M3AAWG"
          end
        end
      end

      def metadata_publisher(node, xml)
        xml.contributor do |c|
          c.role **{ type: "publisher" }
          c.organization do |a|
            a.name "Messaging Malware and Mobile Anti-Abuse Working Group"
            a.abbreviation "M3AAWG"
          end
        end
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
          abbr = IsoDoc::M3d::Metadata.new("en", "Latn", {}).
            stage_abbr(docstatus)
          dn = "#{dn}(#{abbr})" unless abbr.empty?
        end
        node.attr("copyright-year") and dn += ":#{node.attr("copyright-year")}"
        xml.docidentifier dn, **{type: "m3d"}
        xml.docnumber { |i| i << node.attr("docnumber") }
      end

      def metadata_copyright(node, xml)
        from = node.attr("copyright-year") || Date.today.year
        xml.copyright do |c|
          c.from from
          c.owner do |owner|
            owner.organization do |o|
              o.name "Messaging Malware and Mobile Anti-Abuse Working Group"
              o.abbreviation "M3AAWG"
            end
          end
        end
      end

      def title_validate(root)
        nil
      end

      def makexml(node)
        @draft = node.attributes.has_key?("draft")
        super
      end

      def doctype(node)
        d = node.attr("doctype")
        unless %w{policy best-practices supporting-document report}.include? d
          @log.add("Document Attributes", nil, "#{d} is not a legal document type: reverting to 'report'")
          d = "report"
        end
        d
      end

      def document(node)
        init(node)
        ret1 = makexml(node)
        ret = ret1.to_xml(indent: 2)
        unless node.attr("nodoc") || !node.attr("docfile")
          filename = node.attr("docfile").gsub(/\.adoc/, ".xml").
            gsub(%r{^.*/}, "")
          File.open(filename, "w") { |f| f.write(ret) }
          html_converter(node).convert filename unless node.attr("nodoc")
          pdf_converter(node).convert filename unless node.attr("nodoc")
          word_converter(node).convert filename unless node.attr("nodoc")
        end
        @log.write(@filename + ".err") unless @novalid
        @files_to_delete.each { |f| FileUtils.rm f }
        ret
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

      def html_converter(node)
        IsoDoc::M3d::HtmlConvert.new(html_extract_attributes(node))
      end

      def word_converter(node)
        IsoDoc::M3d::WordConvert.new(doc_extract_attributes(node))
      end

      def pdf_converter(node)
        IsoDoc::M3d::PdfConvert.new(html_extract_attributes(node))
      end
    end
  end
end
