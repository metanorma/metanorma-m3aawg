# frozen_string_literal: true

require "metanorma/standoc"
module Metanorma
  module M3aawg
  end
end

module Metanorma
  module M3aawg::Document
  end
end

module Metanorma
  existing = defined?(Metanorma::M3dDocument) && Metanorma::M3dDocument
  if !existing.equal?(Metanorma::M3aawg::Document)
    Metanorma.send(:remove_const, :M3dDocument) if existing
    M3dDocument = Metanorma::M3aawg::Document
  end
end

# OCP adoption: ONE registration in the metanorma-core flavor table
require "metanorma-core"

Metanorma::Core::Flavors.register(Metanorma::Core::Flavor.new(
  name: :m3aawg,
  gem: "metanorma-m3aawg",
  model_root: Metanorma::M3aawg::Document::Root,
  pubid_module: nil,
  renderers: { html: Metanorma::Html::StandardRenderer },
))
