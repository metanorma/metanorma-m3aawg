require "isodoc"
require "isodoc/generic/html_convert"
require_relative "base_convert"
require_relative "init"

module IsoDoc
  module M3AAWG
    class HtmlConvert < IsoDoc::Generic::HtmlConvert
      def configuration
        Metanorma::M3AAWG.configuration
      end

      def colophon(_docxml, body)
        body.div class: "colophon" do |div|
          div << <<~"COLOPHON"
            <p>As with all M<sup>3</sup>AAWG documents that we publish,
            please check the M<sup>3</sup>AAWG website
            (<a href="http://www.m3aawg.org">www.m3aawg.org</a>) for updates to
            this paper.</p>
            <p>&#xa9; #{@meta.get[:docyear]} copyright by the Messaging, Malware
            and Mobile Anti-Abuse Working Group (M<sup>3</sup>AAWG)</p>
          COLOPHON
        end
      end

      include BaseRender
      include Init
    end
  end
end
