Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

# plurimath >= 0.10 requires mml at load time but failed to
declare it in 0.10.0 — explicit so bundler installs it (cf.
metanorma-document, metanorma-oiml).
gem "mml", ">= 2.0"

if File.exist? 'Gemfile.devel'
  eval File.read('Gemfile.devel'), nil, 'Gemfile.devel' # rubocop:disable Security/Eval
end
