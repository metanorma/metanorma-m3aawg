source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec
gem "metanorma-mirror", "~> 1.0"

# Canonical line: the relaton 3.x prerelease monogem over the gem mains.
# The cross-PR feature branches these pins used to track have merged.
gem "metanorma", "~> 2.5.14"
gem "metanorma-standoc", "~> 3.5.7"
gem "metanorma-document", "~> 0.5.3"
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main"
gem "metanorma-core", "~> 0.2.7" # published flavor/taste table (metanorma-core#18)
gem "isodoc", "~> 3.7.9"
gem "relaton", "~> 3.0"
gem "pubid", "~> 2.0"

eval_gemfile("Gemfile.devel") rescue nil

# isodoc compiles its embedded SCSS at render time
gem "sassc-embedded", "~> 1.80"
