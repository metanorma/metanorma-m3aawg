# frozen_string_literal: true

require "bundler/setup"
require "rspec/matchers"
require "metanorma/m3d/document"
require_relative "support/roundtrip_helper"
require_relative "support/shared_roundtrip_examples"

RSpec.describe "M3D document XML round-trip" do
  it_behaves_like "xml round-trip", flavor_dir: "m3d",
                                    doc_class: Metanorma::M3d::Document::Root
end
