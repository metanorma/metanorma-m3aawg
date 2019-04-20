require "isodoc"
require_relative "base_convert"

module IsoDoc
  module M3d
    # A {Converter} implementation that generates CSAND output, and a document
    # schema encapsulation of the document for validation
    class PdfConvert < IsoDoc::PdfConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def convert1(docxml, filename, dir)
        add_image(%w(logo.jpg m3-logo.png))
        super
      end

      def default_fonts(options)
        {
          bodyfont: (options[:script] == "Hans" ? '"SimSun",serif' : '"Overpass",sans-serif'),
          headerfont: (options[:script] == "Hans" ? '"SimHei",sans-serif' : '"Overpass",sans-serif'),
          monospacefont: '"Space Mono",monospace'
        }
      end

      def default_file_locations(_options)
        {
          htmlstylesheet: html_doc_path("htmlstyle.scss"),
          htmlcoverpage: html_doc_path("html_m3d_titlepage.html"),
          htmlintropage: html_doc_path("html_m3d_intro.html"),
          standardstylesheet: nil,
          scripts_pdf: html_doc_path("scripts.pdf.html"),
        }
      end

      def colophon(body, docxml)
        body.div **{ class: "colophon" } do |div|
          div << <<~"COLOPHON"
          <p>As with all M3AAWG documents that we publish, please check the M3AAWG website
          (<a href="http://www.m3aawg.org">www.m3aawg.org</a>) for updates to this paper.</p>
          <p>&copy; {{ docyear }} copyright by the Messaging, Malware and Mobile Anti-Abuse Working Group (M3AAWG)</p>
          COLOPHON
        end
      end

      def googlefonts()
        <<~HEAD.freeze
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i|Space+Mono:400,700" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Overpass:300,300i,600,900" rel="stylesheet">
        HEAD
      end

      def make_body(xml, docxml)
        body_attr = { lang: "EN-US", link: "blue", vlink: "#954F72", "xml:lang": "EN-US", class: "container" }
        xml.body **body_attr do |body|
          make_body1(body, docxml)
          make_body2(body, docxml)
          make_body3(body, docxml)
          colophon(body, docxml)
        end
      end

      def html_toc(docxml)
        docxml
      end

      include BaseRender
    end
  end
end

