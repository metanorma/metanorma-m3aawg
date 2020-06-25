require "isodoc"
require_relative "base_convert"

module IsoDoc
  module M3AAWG
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation

    class WordConvert < IsoDoc::WordConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def default_fonts(options)
        {
          bodyfont: (options[:script] == "Hans" ? '"SimSun",serif' : '"Garamond",serif'),
          headerfont: (options[:script] == "Hans" ? '"SimHei",sans-serif' : '"Garamond",serif'),
          monospacefont: '"Courier New",monospace'
        }
      end

      def default_file_locations(_options)
        {
          htmlstylesheet: html_doc_path("htmlstyle.scss"),
          htmlcoverpage: html_doc_path("html_m3d_titlepage.html"),
          htmlintropage: html_doc_path("html_m3d_intro.html"),
          scripts: html_doc_path("scripts.html"),
          wordstylesheet: html_doc_path("wordstyle.scss"),
          standardstylesheet: html_doc_path("m3d.scss"),
          header: html_doc_path("header.html"),
          wordintropage: html_doc_path("word_m3d_intro.html"),
          ulstyle: "l3",
          olstyle: "l2",
        }
      end

      def colophon(body, docxml)
        section_break(body)
        body.div **{ class: "colophon" } do |div|
        end
      end

      def make_body(xml, docxml)
        body_attr = { lang: "EN-US", link: "blue", vlink: "#954F72" }
        xml.body **body_attr do |body|
          make_body2(body, docxml)
          make_body3(body, docxml)
          colophon(body, docxml)
        end
      end

      def title(isoxml, _out)
        main = isoxml&.at(ns("//title[@language='en']"))&.text
        set_metadata(:doctitle, main)
      end

      include BaseRender
    end
  end
end
