# frozen_string_literal: true

module Metanorma
  module M3aawg
    module Document
      module Metadata
        autoload :M3dBibDataExtensionType,
                 "#{__dir__}/metadata/m3d_bib_data_extension_type"
        autoload :M3dBibliographicItem,
                 "#{__dir__}/metadata/m3d_bibliographic_item"
      end
    end
  end
end
