require "isodoc"
require_relative "./m3dconvert"

module IsoDoc
  module M3d
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation

    class WordConvert < IsoDoc::M3d::Convert
      include IsoDoc::WordConvertModule
      def html_doc_path(file)
        File.join(File.dirname(__FILE__), File.join("html", file))
      end

      def initialize(options)
        super
        @wordstylesheet = generate_css(html_doc_path("wordstyle.scss"), false, default_fonts(options))
        @standardstylesheet = generate_css(html_doc_path("m3d.scss"), false, default_fonts(options))
        @header = html_doc_path("header.html")
        @wordcoverpage = html_doc_path("word_m3d_titlepage.html")
        @wordintropage = html_doc_path("word_m3d_intro.html")
        @ulstyle = "l7"
        @olstyle = "l10"
      end

      ENDLINE = <<~END.freeze
      <v:line id="_x0000_s1026"
 alt="" style='position:absolute;left:0;text-align:left;z-index:251662848;
 mso-wrap-edited:f;mso-width-percent:0;mso-height-percent:0;
 mso-width-percent:0;mso-height-percent:0'
 from="6.375cm,20.95pt" to="10.625cm,20.95pt"
 strokeweight="1.5pt"/>
      END

      def end_line(_isoxml, out)
        out.parent.add_child(ENDLINE)
      end

      def generate_header(filename, dir)
        return unless @header
        template = Liquid::Template.parse(File.read(@header, encoding: "UTF-8"))
        meta = get_metadata
        meta[:filename] = filename
        params = meta.map { |k, v| [k.to_s, v] }.to_h
        File.open("header.html", "w") { |f| f.write(template.render(params)) }
        @files_to_delete << "header.html"
      end

      def header_strip(h)
        h = h.to_s.gsub(%r{<br/>}, " ").sub(/<\/?h[12][^>]*>/, "")
        h1 = to_xhtml_fragment(h.dup)
        h1.traverse do |x|
          x.replace(" ") if x.name == "span" &&
            /mso-tab-count/.match?(x["style"])
          x.remove if x.name == "span" && x["class"] == "MsoCommentReference"
          x.remove if x.name == "a" && x["epub:type"] == "footnote"
          x.replace(x.children) if x.name == "a"
        end
        from_xhtml(h1)
      end
    end
  end
end
