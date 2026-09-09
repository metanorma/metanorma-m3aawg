# frozen_string_literal: true

require "metanorma/iso/html"

module Metanorma
  module M3d
    # HTML format slice for the flavor: the renderer, registered with
    # the harness from m3d/document.rb. Renders iso-style; the M3D root
    # uses the shared standoc sections.
    module Html
      autoload :Renderer, "#{__dir__}/html/renderer"
    end
  end
end
