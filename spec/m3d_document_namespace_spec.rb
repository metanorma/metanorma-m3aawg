# frozen_string_literal: true

# Self-contained: avoids pulling in the gem's full spec_helper (which
# may load unrelated code with pre-existing pubid-* dependency issues).
require "bundler/setup"
require "metanorma/m3d/document"

RSpec.describe "Metanorma::M3d::Document namespace" do
  describe "canonical namespace" do
    it "exposes Metanorma::M3d::Document as a Module" do
      expect(Metanorma::M3d::Document).to be_a(Module)
    end

    it "exposes Root with the canonical name" do
      expect(Metanorma::M3d::Document::Root.name)
        .to eq("Metanorma::M3d::Document::Root")
    end

    it "Root is a lutaml Serializable" do
      expect(Metanorma::M3d::Document::Root < Lutaml::Model::Serializable).to be(true)
    end
  end

  describe "backwards-compat alias" do
    it "Metanorma::M3dDocument aliases to the new namespace" do
      expect(Metanorma::M3dDocument).to eq(Metanorma::M3d::Document)
    end

    it "the alias preserves class identity" do
      expect(Metanorma::M3dDocument::Root.equal?(
               Metanorma::M3d::Document::Root)).to be(true)
    end
  end

  describe "parent namespace" do
    it "Metanorma::Standoc::Document is available" do
      expect(Metanorma::Standoc::Document).to be_a(Module)
    end

    it "Metanorma::StandardDocument alias is available" do
      expect(Metanorma::StandardDocument).to eq(Metanorma::Standoc::Document)
    end
  end
end
