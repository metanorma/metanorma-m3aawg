# frozen_string_literal: true

require "metanorma/standoc"
require "metanorma/iso/document/models"
module Metanorma
  module M3aawg
  end
end

module Metanorma
  module M3aawg::Document
    autoload :Metadata, "metanorma/m3aawg/document/metadata"
    autoload :Root, "metanorma/m3aawg/document/root"
  end
end

module Metanorma
  existing = defined?(Metanorma::M3dDocument) && Metanorma::M3dDocument
  if !existing.equal?(Metanorma::M3aawg::Document)
    Metanorma.send(:remove_const, :M3dDocument) if existing
    M3dDocument = Metanorma::M3aawg::Document
  end
end

require "metanorma/m3aawg/registers"
Metanorma::M3aawg::Registers.setup

# OCP adoption: ONE registration in the metanorma-core flavor table
require "metanorma-core"

Metanorma::Core::Flavors.register(Metanorma::Core::Flavor.new(
  name: :m3aawg,
  gem: "metanorma-m3aawg",
  model_root: Metanorma::M3aawg::Document::Root,
  pubid_module: nil,
  renderers: { html: lambda do |_document, **_options|
    Metanorma::Html::StandardRenderer
  end },
))
