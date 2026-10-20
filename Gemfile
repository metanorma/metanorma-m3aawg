source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec
gem "metanorma-mirror", "~> 1.0"

# Canonical line: the relaton 3.x prerelease monogem over the gem mains.
# The cross-PR feature branches these pins used to track have merged.
gem "metanorma", github: "metanorma/metanorma", branch: "main"
gem "metanorma-standoc", github: "metanorma/metanorma-standoc", branch: "main"
gem "metanorma-document", github: "metanorma/metanorma-document", branch: "main"
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main"
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "main"
gem "isodoc", github: "metanorma/isodoc", branch: "main"
gem "relaton", "~> 3.0.0.pre.alpha"
gem "relaton-bib", "2.2.0.pre.alpha.1"
gem "pubid", github: "pubid/pubid", branch: "main"

eval_gemfile("Gemfile.devel") rescue nil

# isodoc compiles its embedded SCSS at render time
gem "sassc-embedded", "~> 1.80"
