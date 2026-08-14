# frozen_string_literal: true

require "metanorma/standoc"
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
