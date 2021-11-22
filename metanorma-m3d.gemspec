lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "metanorma/m3aawg/version"

Gem::Specification.new do |spec|
  spec.name          = "metanorma-m3aawg"
  spec.version       = Metanorma::M3AAWG::VERSION
  spec.authors       = ["Ribose Inc."]
  spec.email         = ["open.source@ribose.com"]

  spec.summary       = "metanorma-m3d lets you write M3AAWG Documents in AsciiDoc."
  spec.description   = <<~DESCRIPTION
    metanorma-m3d lets you write M3AAWG Documents in AsciiDoc syntax.

    This gem is in active development.

    Formerly known as asciidoctor-m3d, metanorma-m3d.
  DESCRIPTION

  spec.homepage      = "https://github.com/metanorma/metanorma-m3aawg"
  spec.license       = "BSD-2-Clause"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.add_dependency "htmlentities", "~> 4.3.4"
  spec.add_dependency "thread_safe"

  spec.add_dependency "metanorma-generic", "~> 1.11.0"

  spec.add_development_dependency "debug"
  spec.add_development_dependency "equivalent-xml", "~> 0.6"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.6"
  spec.add_development_dependency "rubocop", "~> 1.5.2"
  spec.add_development_dependency "sassc", "~> 2.4.0"
  spec.add_development_dependency "simplecov", "~> 0.15"
  spec.add_development_dependency "timecop", "~> 0.9"
end
