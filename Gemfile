source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec
gem "metanorma-mirror", "~> 1.0"

# Canonical line: the relaton 3.x prerelease monogem over the gem mains.
# The cross-PR feature branches these pins used to track have merged.
gem "metanorma", "~> 2.5.6.pre.alpha"
gem "metanorma-standoc", "~> 3.5.1.pre.alpha"
gem "metanorma-document", "~> 0.5.2.pre.alpha"
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main"
gem "metanorma-core", "~> 0.2.5.pre.alpha" # published flavor/taste table (metanorma-core#18)
gem "isodoc", "~> 3.7.4.pre.alpha"
gem "relaton", "~> 3.0"
gem "relaton-bib", "2.2.0.pre.alpha.1"
gem "pubid", "~> 2.0"

eval_gemfile("Gemfile.devel") rescue nil

# isodoc compiles its embedded SCSS at render time
gem "sassc-embedded", "~> 1.80"
