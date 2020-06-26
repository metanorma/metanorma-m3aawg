require_relative "metadata"
require "fileutils"

module IsoDoc
  module M3AAWG
    module BaseRender
      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
      end
      
      #def add_image(filenames)
        #filenames.each do |filename|
          #FileUtils.cp html_doc_path(filename), File.join(@localdir, filename)
          #@files_to_delete << File.join(@localdir, filename)
        #end
      #end

      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{@xrefs.anchor(annex['id'], :label)} "
          t.br
          t.b do |b|
            name&.children&.each { |c2| parse(c2, b) }
          end
        end
      end

      def i18n_init(lang, script)
        super
        @annex_lbl = "Appendix"
        @labels["annex"] = "Appendix"
      end

      def fileloc(loc)
        File.join(File.dirname(__FILE__), loc)
      end

      def cleanup(docxml)
        super
        term_cleanup(docxml)
      end

      def term_cleanup(docxml)
        docxml.xpath("//p[@class = 'Terms']").each do |d|
          h2 = d.at("./preceding-sibling::*[@class = 'TermNum'][1]")
          h2.add_child("&nbsp;")
          h2.add_child(d.remove)
        end
        docxml
      end
    end
  end
end
