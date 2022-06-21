require_relative "init"
require "metanorma-generic"
require "isodoc"

module IsoDoc
  module M3AAWG
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def configuration
        Metanorma::M3AAWG.configuration
      end

      def annex1(elem)
        lbl = @xrefs.anchor(elem["id"], :label)
        if t = elem.at(ns("./title"))
          t.children = "<strong>#{t.children.to_xml}</strong>"
        end
        prefix_name(elem, "<br/>", lbl, "title")
      end

      include Init
    end
  end
end
