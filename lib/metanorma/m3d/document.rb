# frozen_string_literal: true

require "metanorma/standoc"
require "metanorma/iso/document"
# Forward-declare parent namespace so this file is safe to require
# directly (without first requiring metanorma/m3d.rb).
module Metanorma
  module M3d
  end
end


module Metanorma
  module M3d::Document
    autoload :Metadata, "metanorma/m3d/document/metadata"
    autoload :Root, "metanorma/m3d/document/root"
  end
end


# Backwards-compat alias so external consumers that reference
# Metanorma::M3dDocument keep resolving during the transition.
module Metanorma
  existing = defined?(Metanorma::M3dDocument) && Metanorma::M3dDocument
  if !existing.equal?(Metanorma::M3d::Document)
    Metanorma.send(:remove_const, :M3dDocument) if existing
    M3dDocument = Metanorma::M3d::Document
  end
end

if defined?(Metanorma::Registers::Setup.setup_m3d_register)
  Metanorma::Registers::Setup.setup_m3d_register
end

module Metanorma
  deprecate_constant :M3dDocument
end

require "metanorma-core"

# OCP adoption: ONE registration in the metanorma-core flavor table
# (metanorma-core#18). Lazy: the table exists only on the flavor-table
# line of metanorma-core; skip silently on resolutions without it.
if defined?(Metanorma::Core::Flavors)
  Metanorma::Core::Flavors.register(Metanorma::Core::Flavor.new(
                                      name: :m3d,
                                      gem: "metanorma-m3d",
                                      model_root: Metanorma::M3d::Document::Root,
                                      pubid_module: nil,
                                      renderers: { html: lambda do |_document, **_options|
                                        require "metanorma/m3d/html"
                                        Metanorma::M3d::Html::Renderer
                                      end },
                                    ))
end
